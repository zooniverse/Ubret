class Spectra extends Ubret.Graph
  name: "Spectra"

  constructor: ->
    _.extend @, Ubret.Sequential
    super 

  events:
    'next' : 'nextPage drawGraph'
    'prev' : 'prevPage drawGraph'
    'height' : 'setupGraph drawGraph'
    'width' : 'setupGraph drawGraph'
    'selector' : 'setupGraph'
    'data': 'drawGraph'
    'selection': 'drawGraph'
    'setting:bestFitLine' : 'bestFitLineDraw'
    'setting:fluxLine' : 'fluxLineDraw'
    'setting:emissionLines' : 'emissionLinesDraw'

  apiURL: "http://api.sdss3.org/spectrum"

  loadSpectra: (subject) =>
    url = "#{@apiURL}?mjd=#{subject.mjd}&plate=#{subject.plate}&fiber=#{subject.fiberID}&fields=best_fit,wavelengths,flux&format=json"
    Ubret.Get(url).then(@loadSpectralLines)

  loadSpectralLines: (subject) =>
    url = "#{@apiURL}Lines?id=#{subject.spectrumID}"
    Ubret.Get(url).then (rawLines) ->
      lines = new Object
      for line in rawLines[subject.spectrumID]
        lines[line.name] = {wavelength: line.wavelength, redshift: line.linez} 
      {lines: lines, spectra: subject}

  xDomain: =>
    return unless @spectra
    d3.extent @spectra.wavelengths

  yDomain: =>
    return unless @spectra
    d3.extent @spectra.flux

  drawGraph: =>
    return if _.isEmpty(@preparedData()) or _.isUndefined(@svg)
    [subject] = @currentPageData()
    @loadSpectra(subject).then (specData) =>
      {@spectra, @lines} = specData
      @drawAxis1() 
      @drawAxis2() 
      @fluxLineDraw()
      @bestFitLineDraw()
      @emissionLinesDraw()

  fluxLineDraw: =>
    @svg.selectAll("path.fluxes").remove() if @svg?
    return unless @opts.fluxLine is 'show' and @spectra?
    x = @x()
    y = @y()

    flux = d3.svg.line()
      .x((d, i) => x(@spectra.wavelengths[i]))
      .y((d, i) => y(d))

    @svg.insert("path", ":first-child")
        .datum(@spectra.flux)
        .attr("class", "line fluxes")
        .attr("d", flux)
        .attr('fill', 'none')
        .attr('stroke', 'black')

  bestFitLineDraw: =>
    @svg.selectAll("path.best-fit").remove() if @svg?
    return unless @opts.bestFitLine is 'show' and @spectra?
    x = @x()
    y = @y()

    bestFit= d3.svg.line()
      .x((d, i) => x(@spectra.wavelengths[i]))
      .y((d, i) => y(d))

    @svg.insert("path", "path.flux")
        .datum(@spectra.best_fit)
        .attr("class", "line best-fit")
        .attr("d", bestFit)
        .attr('stroke', "blue")
        .attr('fill', 'none')

  emissionLinesDraw: (redshiftCorrected=true) =>
    @svg.selectAll('line.emissions').remove() if @svg?
    return unless @opts.emissionLines is 'show' and @lines?
    x = @x()

    for name, line of @lines
      multiplier = if redshiftCorrected then (1 + line.redshift) else 1
      @svg.append("line")
        .attr('class', 'emissions')
        .attr("x1", x(line.wavelength * multiplier))
        .attr("x2", x(line.wavelength * multiplier))
        .attr("y1", 0)
        .attr("y2", @graphHeight())
        .style("stroke", "rgb(255,0,0)")
        .style("stroke-width", 0.5)

window.Ubret.Spectra = Spectra