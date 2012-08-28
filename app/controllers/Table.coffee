BaseController = require("./BaseController")

class Table extends BaseController
  events: 
    'click .subject' : 'selection'

  constructor: ->
    super

  name: "Table"

  keys: []

  data: []

  getDataSource: =>
    super.always =>
      @render()

  receiveData: =>
    super
    @render()
  
  render: =>
    super
    @extractKeys @data[0] unless @keys == []
    @append require('views/table')(@)

  selection: (e) =>
    @selected.removeClass('selected') if @selected
    @selected = @el.find(e.currentTarget)
    @selected.addClass('selected')
    @publish([ { message: "selected", item_id: @selected.attr('data-id') } ])

  process: (message) =>
    switch message.message
      when "selected" then @select message.item_id

  extractKeys: (datum) ->
    for key, value of datum
      dataKey = key if typeof(value) != 'function'
      @keys.push dataKey unless dataKey == 'cid' or dataKey == 'id'

  select: (itemId) =>
    @selected.removeClass('selected') if @selected
    @selected = @el.find("tr.subject[data-id='#{itemId}']")
    @selected.addClass('selected')
    @publish([ {message: "selected", item_id: itemId} ])

module.exports = Table