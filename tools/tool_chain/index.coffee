class ToolChain extends U.Tool
  url: "http://localhost:3002/zoo_data/"
  template: require("./templates/tool_chain")

  events: [
    {
      req: ["title", "annotation"],
      opt: ["data", "params.ready"],
      fn: 'render'
    }
  ]

  constructor: ->
    super
    @dataSource = new U.DataSource(@state, @url, @nonDisplayKeys)

  render: ({title, annotation, ready, data}) ->
    @$el.off()
    @$el.html(@template({
      title: title,
      annotation: annotation,
      ready: ready?,
      thumbnail: data?.project('thumb').first()
    }))
    @$el.on('dblclick', '.title', _.bind(@editTitle, @))
    @$el.on('dblclick', '.annotation', _.bind(@editAnnotation, @))

  editTitle: (ev) ->
    @$el.find('.title h2').hide()
    @$el.find('.title input').show().focus()
    @$el.find(".finish-edit").show()
      .on('click', @finishTitleEdit)

  editAnnotation: (ev) ->
    @$el.find('.annotation p').hide()
    @$el.find('.annotation textarea').show().focus()
    @$el.find(".finish-edit").show()
      .on('click', @finishAnnotationEdit)

  finishEdit: ->
    @$el.find(".finish-edit").hide().off()

  finishAnnotationEdit: ->
    @finishEdit()
    annotation = @$el.find('.annotation textarea').val()
    @state.set('annotation', annotation)

  finishTitleEdit: ->
    @finishEdit()
    title = @$el.find(".title input").val()
    @state.set('title', title)

module.exports = ToolChain