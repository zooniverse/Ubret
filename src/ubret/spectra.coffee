class Spectra extends Ubret.BaseTool
  name: "Spectra"
  
  constructor: (selector) ->
    super selector
    @cache = {}
    @opts.bestFitLine = 'show'
    @opts.fluxLine = 'show'
    @opts.emissionLines = 'show'
    @on 'next', @next
    @on 'prev', @prev

  start: =>
    super
    if _.isEmpty @opts.selectedIds
      @selectIds [@opts.data[0].uid]

    subjects = _(@opts.data).filter (d) => 
      d.uid in @opts.selectedIds
    @loadSpectra(subjects[0]) unless _.isEmpty(subjects)

  loadSpectra: (subject) =>
    if @cache["#{subject.plate}-#{subject.mjd}-#{subject.fiberID}"]?
      @subject = @cache["#{subject.plate}-#{subject.mjd}-#{subject.fiberID}"][0]
      @spectralLines = @cache["#{subject.plate}-#{subject.mjd}-#{subject.fiberID}"][1]
      @plot()
    else
      request = new XMLHttpRequest()
      url = "http://api.sdss3.org/spectrum?plate=#{subject.plate}&mjd=#{subject.mjd}&fiber=#{subject.fiberID}&fields=best_fit,wavelengths,flux&format=json"
      request.open("GET", url, true)
      request.onload = (e) =>
        @subject = JSON.parse request.response
        @loadSpectralLines("#{subject.plate}-#{subject.mjd}-#{subject.fiberID}")
      request.send()

  loadSpectralLines: (cacheString) =>
    request = new XMLHttpRequest()
    url = "http://api.sdss3.org/spectrumLines?id=#{@subject.spectrumID}"
    request.open("GET", url, true)
    request.onload = (e) =>
      @spectralLines = new Object
      rawLines = JSON.parse(request.response)[@subject.spectrumID] 
      @spectralLines[line.name] = {wavelength: line.wavelength, redshift: line.linez} for line in rawLines
      @cache[cacheString] = [@subject, @spectralLines]
      @plot()
    request.send()

  plot: =>
    margin =
      top: 20 
      right: 30
      bottom: 80
      left: 80
    @width = @opts.width - margin.left - margin.right
    @height = @opts.height - margin.top - margin.bottom

    @x = d3.scale.linear()
      .range([0, @width])
      .domain(d3.extent(@subject.wavelengths))
    @y = d3.scale.linear()
      .range([@height, 0])
      .domain(d3.extent(@subject.flux))

    @svg = @opts.selector.append('svg')
        .attr('width', @opts.width - 10)
        .attr('height', @opts.height - 10)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.top})")
        .call(d3.behavior.zoom().x(@x).y(@y).scaleExtent([1, 8]).on("zoom", @zoom))
    
    @xAxis = d3.svg.axis()
      .scale(@x)
      .orient("bottom")
      .ticks(8)
    @yAxis = d3.svg.axis()
      .scale(@y)
      .orient("left")

    @svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, #{@height})")
        .call(@xAxis)
      .append('text')
        .attr('y', 30)
        .attr('x', (@width / 2))
        .attr("dy", ".71em")
        .style("text-anchor", "middle")
        .text("Wavelength (Angstroms)")

    @svg.append("g")
        .attr("class", "y axis")
        .call(@yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", -50)
        .attr("x", -(@height / 2) + 100)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Flux (1E-17 erg/cm^2/s/Ang)")

    @fluxLinedDraw() if @opts.fluxLine is 'show'
    @bestFitLinedDraw() if @opts.bestFitLine is 'show'
    @emissionLinesdDraw() if @opts.emissionLines is 'show'
   
  fluxLinedDraw: =>
    fluxLine = d3.svg.line()
      .x((d, i) => @x(@subject.wavelengths[i]))
      .y((d, i) => @y(d))

    @svg.append("path")
        .datum(@subject.flux)
        .attr("class", "line fluxes")
        .attr("d", fluxLine)
        .attr('fill', 'none')
        .attr('stroke', 'black')

  bestFitLinedDraw: =>
    bestFitLine = d3.svg.line()
      .x((d, i) => @x(@subject.wavelengths[i]))
      .y((d, i) => @y(d))

    @svg.append("path")
        .datum(@subject.best_fit)
        .attr("class", "line best-fit")
        .attr("d", bestFitLine)
        .attr('stroke', "blue")
        .attr('fill', 'none')

  emissionLinesdDraw: (redshiftCorrected=true) =>
    for name, line of @spectralLines
      multiplier = if redshiftCorrected then (1 + line.redshift) else 1
      @svg.append("line")
        .attr("x1", @x(line.wavelength * multiplier))
        .attr("x2", @x(line.wavelength * multiplier))
        .attr("y1", 0)
        .attr("y2", @height)
        .style("stroke", "rgb(255,0,0)")
        .style("stroke-width", 0.5)


window.Ubret.Spectra = Spectra