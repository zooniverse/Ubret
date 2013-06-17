Sequential = 
  perPage: 1

  pageSort: (data) -> 
    if _.isEmpty(@opts.selectedIds) or _.isNull(@opts.selectedIds)
      data
    else
      _.filter data, (d) => 
        d.uid in @opts.selectedIds

window.Ubret.Sequential = _.extend(Sequential, Ubret.Paginated)
