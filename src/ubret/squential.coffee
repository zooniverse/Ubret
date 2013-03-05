class Sequential extends Ubret.BaseTool
  next: =>
    lastUid = _(@opts.selectedIds).last()
    lastSubject = _(@opts.data).find((d) => d.uid is lastUid)
    index = _(@opts.data).indexOf(lastSubject) + 1
    if index >= @opts.data.length
      index = 0
    @selectIds [@opts.data[index].uid]

  prev: =>
    lastUid = _(@opts.selectedIds).first()
    lastSubject = _(@opts.data).find((d) => d.uid is lastUid)
    index = _(@opts.data).indexOf(lastSubject) - 1
    if index is 0
      index = @opts.data.length - 1 
    @selectIds [@opts.data[index].uid]

window.Ubret.Sequential = Sequential
