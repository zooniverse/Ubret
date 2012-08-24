BaseController = require("./BaseController")

class Table extends BaseController
  events: 
    'click .subject' : 'selection'

  constructor: ->
    super
    @render()

  name: "Table"

  render: =>
    @html require('views/table')(@data)

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

module.exports = Table