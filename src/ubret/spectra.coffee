class Spectra extends Ubret.BaseTool
  name: "Spectra"
  
  constructor: (selector) ->
    super selector
    @on 'next', @next
    @on 'prev', @prev

  start: =>
    super
    subjects = _(@opts.data).filter (d) => 
      d.uid in @opts.selectedIds

    if _.isEmpty subjects
      @selectIds [@opts.data[0].uid]
      @start()
    else
      @loadSpectra(subjects[0])

  loadSpectra: (subject) =>
    request = new XMLHttpRequest()
    url = "http://api.sdss3.org/spectrum?plate=#{subject.plate}&mjd=#{subject.mjd}&fiber=#{subject.fiberID}&fields=best_fit,wavelengths,flux&format=json"
    request.open("GET", url, true)
    request.onload = (e) =>
      subject = JSON.parse request.response
      @loadSpectralLines subject
    request.send()

  loadSpectralLines: (subject) =>
    request = new XMLHttpRequest()
    url = "http://api.sdss3.org/spectrumLines?id=#{subject.spectrumID}"
    request.open("GET", url, true)
    request.onload = (e) =>
      lines = new Object
      rawLines = JSON.parse(request.response)[subject.spectrumID]
      lines[line.name] = line.wavelength for line in rawLines
      @plot(subject.wavelengths, subject.flux, subject.best_fit, lines)
    request.send()

  plot: (wavelengths, fluxes, bestFit, spectralLines) =>
    margin =
      top: 14
      right: 30
      bottom: 100 
      left: 80
    width = @opts.width - margin.left - margin.right
    height = @opts.height - margin.top - margin.bottom
    
    x = d3.scale.linear()
      .range([0, width])
      .domain(d3.extent(wavelengths))
    y = d3.scale.linear()
      .range([0, height])
      .domain(d3.extent(fluxes))
    x.ticks(8)
    
    @xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
    @yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
    
    @fluxLine = d3.svg.line()
      .x (d, i) =>
        return x(wavelengths[i])
      .y (d, i) => return y(d)

    @bestFitLine = d3.svg.line()
      .x (d, i) =>
        return x(wavelengths[i])
      .y (d, i) => return y(d)

    @svg = @opts.selector.append('svg')
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.top})")
        .call(d3.behavior.zoom().x(x).y(y).scaleExtent([1, 8]).on("zoom", @zoom))

    @svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, #{height})")
        .call(@xAxis)
      .append('text')
        .attr('y', 30)
        .attr('x', (width / 2))
        .attr("dy", ".71em")
        .style("text-anchor", "middle")
        .text("Angstroms")

    @svg.append("g")
        .attr("class", "y axis")
        .call(@yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", -50)
        .attr("x", -(height / 2) + 100)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Flux (1E-17 erg/cm^2/s/Ang)")

    @svg.append("path")
        .datum(fluxes)
        .attr("class", "line fluxes")
        .attr("d", @fluxLine)
        .attr('fill', 'none')
        .attr('stroke', 'black')
        
    @svg.append("path")
        .datum(bestFit)
        .attr("class", "line best-fit")
        .attr("d", @bestFitLine)
        .attr('stroke', "blue")
        .attr('fill', 'none')
        
    # Drawing spectral lines
    for name, wavelength of spectralLines
      @svg.append("line")
        .attr("x1", x(wavelength))
        .attr("x2", x(wavelength))
        .attr("y1", 0)
        .attr("y2", height)
        .style("stroke", "rgb(255,0,0)")
        .style("stroke-width", 0.5)


window.Ubret.Spectra = Spectra