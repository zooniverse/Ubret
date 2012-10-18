BaseController = require('./BaseController')
_ = require('underscore/underscore')

class Spectra extends BaseController
  
  name: "Spectra"
  
  constructor: ->
    super
    console.log 'Spectra'
    @subscribe @subChannel, @process
    @bind 'data-received', @plot
  
  render: =>
    console.log "index", @index
    @html require('../views/spectra')({index: @index})
  
  zoom: =>
    @svg.select(".x.axis").call(@xAxis)
    @svg.select(".y.axis").call(@yAxis)
    @svg.select("path.fluxes").attr("d", @fluxLine)
    @svg.select("path.best-fit").attr("d", @bestFitLine)
    
  plot: =>
    wavelengths = @data[0].wavelengths
    fluxes = @data[0].flux
    bestFit = @data[0].best_fit
    
    margin =
      top: 14
      right: 10
      bottom: 14
      left: 10
    width = 370 - margin.left - margin.right
    height = 200 - margin.top - margin.bottom
    
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
    
    @svg = d3.select("#spectra-#{@index}").append('svg')
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
      .append('g')
        .attr('transform', "translate(#{margin.left}, #{margin.top})")
        .call(d3.behavior.zoom().x(x).y(y).scaleExtent([1, 8]).on("zoom", @zoom))
    
    @svg.append("area")
      .attr('width', width + margin.left + margin.right)
      .attr('height', height + margin.top + margin.bottom)
    
    @svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, #{height})")
        .call(@xAxis)
    @svg.append("g")
        .attr("class", "y axis")
        .call(@yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Flux (1E-17 erg/cm^2/s/Ang)")
    @svg.append("path")
        .datum(fluxes)
        .attr("class", "line fluxes")
        .attr("d", @fluxLine)
        
    @svg.append("path")
        .datum(bestFit)
        .attr("class", "line best-fit")
        .attr("d", @bestFitLine)

module.exports = Spectra