Graph = require('tools/graph')

class Spectra extends Graph
  name: "Spectra"

  mixins: [require('tools/mixins/sequential')]

  apiURL: "http://api.sdss3.org/spectrum"

  format: d3.format('.0f')

  constructor: (settings, parent) ->
    # Create GraphData from Subject
    @events[1].req = ['subject']

    # Set Permanent Axes
    settings.xAxis = 'wavelengths'
    settings.yAxis = 'flux'

    super settings, parent

  loadSpectra: ({mjd, sdss_spec_id, plateid, plate, fiberID, fiberid}) ->
    url = @apiURL + "?"
    if sdss_spec_id?
      url = url + "id=#{sdss_spec_id}"
    else if mjd? and (plateid? or plate?) and (fiberID? or fiberid?)
      url = url + "mjd=#{mjd}&"
      url = url + "plate=#{plate or plateid}&"
      url = url + "fiber=#{fiberID or fiberid}"
    else
      promise = new $.Promise()
      promise.reject('No Info')
      return promise
    url = url + "&fields=best_fit,wavelengths,flux&format=json"
    return $.get(url).then(_.bind(@loadSpectralLines, @))

  loadSpectralLines: (subject) ->
    url = "#{@apiURL}Lines?id=#{subject.spectrumID}"
    $.get(url).then (rawLines) ->
      lines = new Object
      for line in rawLines[subject.spectrumID]
        lines[line.name] = {wavelength: line.wavelength, redshift: line.linez} 
      {lines: lines, spectra: subject}

  domain: (subject, axis) ->
    d3.extent(subject[axis])

  graphData: ({subject}) ->
    @loadSpectra(subject).then((({lines, spectra}) =>
      @state.set('lines', lines)
      @state.set('graphData', spectra)), _.bind(@drawSorry, @))

  render: ->
    #noop until I can resolve this

  drawSorry: ->
    @chart.selectAll('g.sorry').remove()
    @chart.selectAll('path').remove()
    @chart.selectAll('line').remove()
    @chart.selectAll('.axis').remove()
    @chart.append('g').attr('class', 'sorry')
      .append('text')
      .attr('text-anchor', 'middle')
      .attr('y', @graphHeight() / 2)
      .attr('x', @graphWidth() / 2)
      .text("Sorry not enough information to retrieve SDSS Spectra")

  drawGraph: ({graphData, xScale, yScale, height}) ->
    @chart.selectAll('g.sorry').remove()
    @fluxLineDraw(graphData, xScale, yScale)
    @bestFitLineDraw(graphData, xScale, yScale)
    @emissionLinesDraw(xScale, height)

  fluxLineDraw: ({wavelengths, flux}, x, y)->
    [fluxLine] = @state.get('fluxLine')
    @chart.selectAll("path.fluxes").remove() if @chart?
    return unless fluxLine if 'show'

    fluxSvgLine = d3.svg.line()
      .x((d, i) -> x(wavelengths[i]))
      .y((d, i) -> y(d))

    @chart.insert("path", ":first-child")
        .datum(flux)
        .attr("class", "line fluxes")
        .attr("d", fluxSvgLine)
        .attr('fill', 'none')
        .attr('stroke', 'black')

  bestFitLineDraw: ({wavelengths, best_fit}, x, y) ->
    [bestFitLine] = @state.get('bestFitLine')
    @chart.selectAll("path.best-fit").remove() if @chart?
    return unless bestFitLine is 'show'

    bestFit = d3.svg.line()
      .x((d, i) -> x(wavelengths[i]))
      .y((d, i) -> y(d))

    @chart.insert("path", "path.flux")
        .datum(best_fit)
        .attr("class", "line best-fit")
        .attr("d", bestFit)
        .attr('stroke', "blue")
        .attr('fill', 'none')

  emissionLinesDraw: (x, height, redshiftCorrected=true) ->
    [lines, emissionLines] = @state.get('lines', 'emissionLines')
    @chart.selectAll('line.emissions').remove()
    return unless emissionLines is 'show'

    chartLines = @chart.selectAll("line").data(_.pairs(lines), ([name]) -> name)

    chartLines.enter().append('line')
      .attr('class', 'emissions')

    chartLines.attr("x1", ([_, line]) -> x(line.wavelength * (1 + line.redshift)))
      .attr("x2", ([_, line]) -> x(line.wavelength * (1 + line.redshift)))
      .attr("y1", 0)
      .attr("y2", height - @marginTop)
      .style("stroke", "rgb(255,0,0)")
      .style("stroke-width", 0.5)

module.exports = Spectra