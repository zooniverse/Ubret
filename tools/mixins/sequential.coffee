Paginated = require('tools/mixins/paginated')

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
      opt: ['width', 'height']
      fn: 'render'
    }
  ]

  perPage: 1

  pageData: ({data, selection}) -> 
    if (selection? && !_.isEmpty(selection))
      data.filter((d) -> d.uid in selection)
    @state.set('pagedData', data.toArray())

module.exports = _.extend({}, Paginated, Sequential)
