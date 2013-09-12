class ToolChain extends U.Tool
  className: "tool-chain"

  template: require("./templates/tool_chain")

  settings: [require("tools/settings/data_source")]

  events: [
    {
      req: ["title", "annotation"],
      opt: ["data", "dataError"],
      fn: 'render'
    }
  ]

  domEvents: {
    'dblclick .title' : 'editTitle'
    'dblclick .annotation' : 'editAnnotation'
    'click .finish-edit' : 'finishEdit'
  }

  constructor: (settings, parent=null) ->
    super settings, parent
    @state.set('params.type', 'talk-collection')
    unless parent
      @dataSource = new U.DataSource(@state, @url, @nonDisplayKeys)

  url: ->
    user = @state.get('user')
    project = @state.get('project')
    "http://localhost:3002/user/#{user}/project/#{project}/collection/" 

  render: ({title, annotation, data, dataError}) ->
    @$el.off('dblclick')
    @$el.html(@template({
      title: title,
      annotation: annotation,
      thumbnail: data?.project('thumb').first()[0].thumb
      data: data
      dataError: dataError
    }))
    @$el.on('dblclick', '.title', _.bind(@editTitle, @))
    @$el.on('dblclick', '.annotation', _.bind(@editAnnotation, @))

  editTitle: (ev) ->
    @$el.find('.title h2').hide()
    @$el.find('.title input').show().focus()
    @$el.find(".finish-edit").show()

  editAnnotation: (ev) ->
    @$el.find('.annotation p').hide()
    @$el.find('.annotation textarea').show().focus()
    @$el.find(".finish-edit").show()

  finishEdit: ->
    @$el.find(".finish-edit").hide().off()
    annotation = @$el.find('.annotation textarea').val()
    @state.set('annotation', annotation)
    title = @$el.find(".title input").val()
    @state.set('title', title)

  setTalkCollections: (cols) ->
    @state.set('talk-collections', cols)

  setUser: (id) ->
    unless @state.get('user')[0]?
      @state.set('user', id);

module.exports = ToolChain