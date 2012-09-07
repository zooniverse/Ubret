BaseController = require("./BaseController")
_ = require ("underscore/underscore")

class Table extends BaseController
  elements: 
    'input[name="filter"]' : 'filter'

  events: 
    'click .subject' : 'selection'
    'click .delete'  : 'removeColumn'
    'click .remove_filter' : 'onRemoveFilter'
    submit: 'onSubmit'

  constructor: ->
    super

  name: "Table"

  start: =>
    @render()
  
  render: =>
    @keys = new Array
    @extractKeys @data[0]
    @filterData()
    @html require('views/table')(@)

  selection: (e) =>
    @selected.removeClass('selected') if @selected
    @selected = @el.find(e.currentTarget)
    @selected.addClass('selected')
    @publish([ { message: "selected", item_id: @selected.attr('data-id') } ])

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

  onRemoveFilter: (e) =>
    filter = (filter for filter in @filters when filter.id is $(e.currentTarget).data('id'))
      # filter = _.find @filters, (e) ->

      # filter.id == $(e.currentTarget).data('id') in fil
    @removeFilter filter
    
  onSubmit: (e) =>
    e.preventDefault()
    @addFilter @parseFilter @filter.val()

  parseFilter: (string) =>
    tokens = string.split " "
    filter = @processFilterArray tokens
    filter = "return" + filter.join " "
    filterFunc = new Function( "item", filter )
    filterID = _.uniqueId "filter_"
    return {id: filterID, text: string, func: filterFunc}

  processFilterArray: (tokens, filters=[]) =>
    nextOr = _.indexOf tokens, "or"
    nextAnd = _.indexOf tokens, "and"
    if ((nextOr < nextAnd) or (nextAnd == -1)) and (nextOr != -1)
      predicate = tokens.splice(0, nextOr)
      filters.push @parsePredicate predicate
      filters.push "||"
    else if ((nextAnd < nextOr) or (nextOr == -1)) and (nextAnd != -1)
      predicate = tokens.splice(0, nextAnd)
      filters.push @parsePredicate predicate
      filters.push "&&"
    else
      predicate = tokens 
      filters.push @parsePredicate predicate
    unless predicate == tokens
      @processFilterArray tokens.splice(1), filters 
    else
      return filters

  parsePredicate: (predicate) ->
    limiter = _.last predicate
    comparison = _.find predicate, (item) ->
      item in ['equal', 'equals', 'greater', 'less', 'not', '=', '>', '<', '!=', '<=', '>=']

    isIndex = _.indexOf predicate, "is"
    comparisonIndex = _.indexOf predicate, comparison

    fieldEnd = if isIndex < comparisonIndex then isIndex else comparisonIndex

    field = predicate.splice(0, fieldEnd).join " "

    switch comparison
      when 'equal' then operator = '=='
      when 'equals' then operator = '=='
      when 'greater' then operator = '>'
      when 'less' then operator = '<'
      when 'not' then operator = '!='
      when '=' then operator = '=='
      else operator = comparison

    return "(item['#{@uglifyKey(field)}'] #{operator} #{parseFloat(limiter)})"




module.exports = Table