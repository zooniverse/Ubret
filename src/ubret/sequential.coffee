Ubret.Sequential = 
  selectSubject: ->
    if _.isEmpty(@opts.data) then return
    if _.isEmpty @opts.selectedIds
      @subject = [@opts.data[0]] 
    else
      @subject = _.filter @opts.data, (d) => d.uid is @opts.selectedIds[0]
      @subject = [@opts.data[0]] if _.isEmpty @subject 

  next: ->
    lastUid = _(@opts.selectedIds).last()
    lastSubject = _(@opts.data).find((d) => d.uid is lastUid)
    index = _(@opts.data).indexOf(lastSubject) + 1
    if index >= @opts.data.length
      index = 0
    @selectIds [@opts.data[index].uid]

  prev: ->
    lastUid = _(@opts.selectedIds).first()
    lastSubject = _(@opts.data).find((d) => d.uid is lastUid)
    index = _(@opts.data).indexOf(lastSubject) - 1
    if index is 0
      index = @opts.data.length - 1 
    @selectIds [@opts.data[index].uid]
