BaseController = require("./BaseController")

class Table extends BaseController
  elements: 
    'input[name="filter"]' : 'filter'

  events: 
    'click .subject' : 'selection'
    'click .delete'  : 'removeColumn'
    submit: 'onSubmit'

  constructor: ->
    super

  name: "Table"

  data: []

  filters: []

  start: =>
    @render()
  
  render: =>
    @keys = new Array
    @extractKeys @data[0]
    @filterData()
    console.log @filteredData
    @html require('views/table')(@)

  selection: (e) =>
    @selected.removeClass('selected') if @selected
    @selected = @el.find(e.currentTarget)
    @selected.addClass('selected')
    @publish([ { message: "selected", item_id: @selected.attr('data-id') } ])

  process: (message) =>
    switch message.message
      when "selected" then @select message.item_id

  select: (itemId) =>
    @selected.removeClass('selected') if @selected
    @selected = @el.find("tr.subject[data-id='#{itemId}']")
    @selected.addClass('selected')
    @publish([ {message: "selected", item_id: itemId} ])

  removeColumn: (e) =>
    target = $(e.currentTarget)
    index = target.closest('th').prevAll('th').length
    target.parents('table').find('tr').each ->
      $(@).find("td:eq(#{index}), th:eq(#{index})").remove()

  onSubmit: (e) =>
    e.preventDefault()
    @filters.push @parseFilter @filter.val()
    @render()

module.exports = Table