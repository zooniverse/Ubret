class Prompt extends U.Tool
  name: 'Prompt'
  className: 'prompt'
  template: require('./templates/prompt')

  defaultEventHandlers: {
    'selection' : ['childSelection']
  }

  events: [
    {
      req: ['statements']
      opt: ['statements.*'] 
      fn: 'render'
    },
    {
      req: ['invokers', 'data']
      opt: []
      fn: 'childData'
    },
    {
      req: ['statements']
      opt: ['statements.*']
      fn: 'executeStatements'
    }
  ]

  constructor: (settings, parent) ->
    unless settings.statements
      settings.statements = []
    super settings, parent
    @state.with(['statements'], @render, @)()

  domEvents: {
    'click .remove' : 'removeStatement'
    'click .execute' : 'setStatement'
  }

  render: (state) ->
    @$el.off()
    @$el.html(@template(state))
    @delegateEvents()

  removeStatement: (ev) ->
    str = ev.target.dataset.string
    statements = _.without(@state.get('statements')[0], str)
    @state.set('statements', statements)

  setStatement: (ev) ->
    statement = @$el.find('input.statement').val()
    return if _.isEmpty(statement)
    statements = (@state.get('statements')[0] || []).concat(statement)
    @state.set('statements', statements)

  executeStatements: ({statements}) ->
    fns = _.map(statements, (statement) ->
      Fql.Parser.parse(statement)[0].eval();
    )
    @state.set('invokers', fns)

  childData: ({invokers, data}) ->
    data = _.reduce(invokers, ((m, i) ->
      if i.field?
        i = {name: i.field, fn: i.func}
        m.addField(i)
      else
        m.filter(i.func)), data)
    @state.set('childData', data)

module.exports = Prompt
