Paginated = require('tools/mixins/paginated')

Sequential = 
  events: [
    {
      req: ['data', 'currentPage']
      opt: ['selection']
      fn: 'pageData'
    },
    {
      req: ['pagedData', 'currentPage']
      opt: []
      fn: 'subject'
    },
    {
      req: ['subject']
      opt: ['width', 'height']
      fn: 'render'
    },
    {
      req: ['subject']
      opt: []
      fn: 'childSelection'
    },
    {
      req: ['currentPage']
      opt: []
      fn: 'drawButtons'
    }
  ]

  perPage: 1

  pageData: ({data, selection, currentPage}) -> 
    if (selection? && !_.isEmpty(selection))
      data = data.filter((d) -> d.uid in selection)
    data = data.toArray()
    @state.set('pages', data.length)
    @state.set('currentPage', @currentPage(currentPage))
    @state.set('pagedData', data)

  subject: ({pagedData, currentPage}) ->
    @state.set('subject', pagedData[currentPage])

  childSelection: ({subject}) ->
    unless subject?
      return
    @state.set('childSelection', [subject.uid])

module.exports = _.extend({}, Paginated, Sequential)
