class ColorMagnitudeChart extends Ubret.Scatterplot
  name: "Color Magnitude"

  probabilities: _(Ubret.GalaxyProbabilities.split('\n')).chain()
    .map((i) -> i.split(' ')).flatten()
    .reduce(((m, v, i) -> 
      unless v is "0.0"
        y = if i > 150 then Math.floor(i / 150) else 0
        m.push
          x: if i > 150 then i - (150 * y) else i 
          y: y
          v: parseFloat(v) * 1000000
      m), [])
    .value()

  constructor: (options) ->
    super
    @brushEnabled = false
    @fields({field: 'color', func: (i) -> i.u - i.r}, false)
    @opts.axis1 = 'abs_r'
    @opts.axis2 = 'color'

  yDomain: =>
    [-2, 4]

  xDomain: =>
    [-18, -23]

  setupGraph: =>
    super
    return unless @svg?
    blockWidth = @probXScale()(1) - @probXScale()(0)
    blockHeight = @probYScale()(0) - @probYScale()(1)

    colorScale = @colorScale()
    opacityScale = @opacityScale()
    xScale = @probXScale()
    yScale = @probYScale()

    @svg.selectAll('rect.prob-sq').remove()

    blocks = @svg.selectAll('rect.prob-sq')
     .data(@probabilities)
        
    blocks.enter()
      .append('rect').attr('class', 'prob-sq')
      .attr('x', (d) => xScale(d.x))
      .attr('y', (d) => yScale(d.y))
      .attr('height', blockHeight)
      .attr('width', blockWidth)
      .attr('fill', (d) => colorScale(d.v))
      .attr('opacity', (d) => opacityScale(d.v))
      .on('mouseover', @displayTooltip)
      .on('mouseout', @displayTooltip)

  colorScale: =>
    d3.scale.linear()
      .domain(d3.extent(_.pluck(@probabilities, 'v')))
      .range(['blue', 'red'])

  opacityScale: =>
    d3.scale.linear()
      .domain(d3.extent(_.pluck(@probabilities, 'v')))
      .range([0.3, 1])

  probXScale: =>
    d3.scale.linear()
      .domain([0, 149])
      .range([0, @graphWidth()])

  probYScale: =>
    d3.scale.linear()
      .domain([0, 149])
      .range([@graphHeight(), 0])

  displayTooltip: (d) =>
    value = if d.v? then d.v else 0

    @svg.selectAll('text.tooltip').remove()
    @svg.append('text')
      .attr('class', 'tooltip')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth() / 2 + 150)
      .attr('y', @graphHeight() + 50)
      .text("Distrubtion Porbability: #{@format(value)} x 10^-6")

window.Ubret.ColorMagnitudeChart = ColorMagnitudeChart
