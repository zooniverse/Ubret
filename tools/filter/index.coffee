class Filter extends U.Tool
  name: "Filter"
  classname: "filter"

  newFilterTemplate: require('./templates/new_filter')
  filterTemplate: require('./templates/filter')

  events: [
    {
      req: ['filters.*']
      opt: []
      fn: 'render'
    },
    {
      req: ['filters.*']
      opt: []
      fn: 'childData'
    }
  ]

  domEvents: {
    'click .close' : 'removeFilter'
    'click .add' : 'addFilter'
  }

  render: ({filters}) ->
    @$el.off()
    @$el.remove()
    _.each(filters, ((f) -> @$el.append(@filterTemplate(f))), @)
    @$el.append(@newFilterTemplate())
    @delegateEvents()

module.exprots = Filter
