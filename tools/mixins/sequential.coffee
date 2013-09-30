Paginated = require('mixins/paginated')

Sequential = 
  events: [
    {
      req: ['data']
      opt: ['selection']
      fn: 'pageData'
    },
    {
      req: ['pagedData']
      opt: []
      fn: 'totalPages'
    },
    {
      req: ['pagedData', 'currentPage']
      opt: []
      fn: 'render'
    },
    {
      req: ['pages', 'currentPage']
      opt: []
      fn: 'drawButtons'
    }
  ]

  perPage: 1

  pageData: ({data, selection}) -> 
    if (selection? && !_.isEmpty(selection))
      data.filter((d) -> d.uid in selection)
    @state.set('pagedData', data.toArray())

module.exports = _.extend({}, Paginated, Sequential)
