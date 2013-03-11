class Spectra extends Ubret.Graph
  name: "Spectra"

  cache: {}
  
  constructor: ->
    _.extend @, Ubret.Sequential
    super 

  defaults:
    margin: {left: 70, top: 20, bottom: 80, right: 20}
    bestFitLine: 'show'
    fluxLine: 'show'
    emissionLines: 'show'
    axis1: 'Wavelengths (angstroms)'
    axis2: 'Flux (1E-17 erg/cm^2/s/Ang)'

  events:
    'selector height width' : 'setupGraph'
    'data selection' : 'spectraSubject'
    'width height spectra-loaded' : 'drawGraph'
    'setting:bestFitLine' : 'bestFitLineDraw'
    'setting:fluxLine' : 'fluxLineDraw'
    'setting:emissionLines' : 'emissionLinesDraw'
    'next' : 'next'
    'prev' : 'prev'

  apiURL: "http://api.sdss3.org/spectrum"

  spectraSubject: =>
    @selectSubject()
    if @subject? 
      [@subject] = @subject
      key = "#{@subject.plate}-#{@subject.mjd}-#{@subject.fiberID}"
      cached = @cache[key]
      if cached?
        return cached
      else
        @loadSpectra() 
    [undefined, undefined]

  loadSpectra: () =>
    request = new XMLHttpRequest()
    url = "#{@apiURL}?plate=#{@subject.plate}&mjd=#{@subject.mjd}&fiber=#{@subject.fiberID}&fields=best_fit,wavelengths,flux&format=json"
    request.open("GET", url, true)
    request.onload = =>
      subject = JSON.parse request.response
      @loadSpectralLines(subject)
    request.send()

  loadSpectralLines: (subject) =>
    request = new XMLHttpRequest()
    url = "#{@apiURL}Lines?id=#{subject.spectrumID}"
    request.open("GET", url, true)
    request.onload = (e) =>
      lines = new Object
      rawLines = JSON.parse(request.response)[subject.spectrumID] 
      for line in rawLines
        lines[line.name] = {wavelength: line.wavelength, redshift: line.linez} 
      @cache["#{@subject.plate}-#{@subject.mjd}-#{@subject.fiberID}"] = [subject, lines]
      @trigger 'spectra-loaded'
    request.send()

  xDomain: =>
    [subject, line] = @spectraSubject()
    return unless subject?
    d3.extent subject.wavelengths

  yDomain: =>
    [subject, line] = @spectraSubject()
    return unless subject?
    d3.extent subject.flux

  drawGraph: =>
    @drawAxis1()
    @drawAxis2()
    @fluxLineDraw()
    @bestFitLineDraw()
    @emissionLinesDraw()

  fluxLineDraw: =>
    [subject, lines] = @spectraSubject()
    @svg.selectAll("path.fluxes").remove() if @svg?
    return unless @opts.fluxLine is 'show' and subject?
    x = @x()
    y = @y()

    flux = d3.svg.line()
      .x((d, i) => x(subject.wavelengths[i]))
      .y((d, i) => y(d))

    @svg.insert("path", ":first-child")
        .datum(subject.flux)
        .attr("class", "line fluxes")
        .attr("d", flux)
        .attr('fill', 'none')
        .attr('stroke', 'black')

  bestFitLineDraw: =>
    [subject, lines] = @spectraSubject()
    @svg.selectAll("path.best-fit").remove() if @svg?
    return unless @opts.bestFitLine is 'show' and subject?
    x = @x()
    y = @y()

    bestFit= d3.svg.line()
      .x((d, i) => x(subject.wavelengths[i]))
      .y((d, i) => y(d))

    @svg.insert("path", "path.flux")
        .datum(subject.best_fit)
        .attr("class", "line best-fit")
        .attr("d", bestFit)
        .attr('stroke', "blue")
        .attr('fill', 'none')

  emissionLinesDraw: (redshiftCorrected=true) =>
    [subject, lines] = @spectraSubject()
    @svg.selectAll('line.emissions').remove() if @svg?
    return unless @opts.emissionLines is 'show' and lines?

    for name, line of lines
      multiplier = if redshiftCorrected then (1 + line.redshift) else 1
      @svg.append("line")
        .attr('class', 'emissions')
        .attr("x1", @x()(line.wavelength * multiplier))
        .attr("x2", @x()(line.wavelength * multiplier))
        .attr("y1", 0)
        .attr("y2", @graphHeight())
        .style("stroke", "rgb(255,0,0)")
        .style("stroke-width", 0.5)


window.Ubret.Spectra = Spectra