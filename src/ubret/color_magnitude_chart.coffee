class ColorMagnitudeChart extends Ubret.Scatterplot
  name: "Color Magnitude"

  probabilities: _(Ubret.GalaxyProbabilities.split('\n')).chain()
    .map((d) -> d.split(' ')).flatten()
    .reduce(((m, v, i) -> 
      unless v is "0.0"
        y = if i > 80 then Math.floor(i / 80) else 0
        m.push
          x: if i > 80 then i - (80 * y) else i 
          y: y
          v: parseFloat(v) * 1000000
      m), [])
    .sortBy((d) -> -d.v)
    .map((d, i) -> d.r = i; d)
    .value()

  constructor: (options) ->
    super
    @brushEnabled = false
    @fields({field: 'color', func: (i) -> i.u - i.r}, false)
    @opts.axis1 = 'abs_r'
    @opts.axis2 = 'color'

  graphWidth: =>
    super - 150 

  yDomain: =>
    domain = super
    if domain
      [min, max] = domain
      [(if min < -2 then min else -2), (if max > 4 then max else 4)]
    else
      [-2, 4]

  xDomain: =>
    domain = super
    if domain
      [min, max] = domain
      [(if min > -18 then min else -18), (if max < -23 then max else -23)]
    else
      [-18, -23]

  drawData: =>
    return unless @svg?
    blockWidth = @probXScale()(1) - @probXScale()(0)
    blockHeight = @probYScale()(0) - @probYScale()(1)

    colorScale = @colorScale()
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
      .on('mouseover', @displayTooltip)

    super

  colorScale: =>
    d3.scale.linear()
      .domain(d3.extent(_.pluck(@probabilities, 'v')))
      .range(['#bbbbff', 'red'])

  probXScale: =>
    x = @x()
    d3.scale.linear()
      .domain([0, 79])
      .range([x(-18), x(-23)])

  probYScale: =>
    y = @y()
    d3.scale.linear()
      .domain([0, 79])
      .range([y(-2), y(4)])

  displayTooltip: (d) =>
    @value = if d.r? then d else @value
    @lastEvent = d3.event
    count = @probabilities.length
    percentile = ((1 - @value.r / count) * 100).toFixed(2)
    text = "Distribution Rank: #{@value.r}/#{count} (#{percentile}th percentile)"

    @svg.selectAll('text.tooltip').remove()
    @svg.append('text')
      .attr('class', 'tooltip')
      .attr('text-anchor', 'middle')
      .attr('x', @graphWidth() / 2 + 150)
      .attr('y', @graphHeight() + 50)
      .text(text)
    @displayImages(@value)

  displayImages: (d) =>
    images = Ubret.GalaxyImages[d.x][d.y]
    @d3el.selectAll('img.example').remove()
    imageTags = @d3el.selectAll('img.example')
      .data(images)

    imageTags.enter().append('img')
      .attr('class', 'example')
      .attr('src', (d) -> "http://galaxyzoo.org/subjects/standard/" + d)
      .attr('width', 120)
      .attr('style', (d, i) -> "top: #{i * 125 + 30}px")

window.Ubret.ColorMagnitudeChart = ColorMagnitudeChart
