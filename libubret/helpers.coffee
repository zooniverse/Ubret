U._bindContext = (fns, ctx) ->
  return _.map(fns, (fn) -> _.bind(fn, ctx))

U.identity = (a) -> a

U.dispatch = (dispatchFn, obj, ctx) ->
  dispatch = _.map(obj, (fns, dispatchVal) ->
    dispatchVal = dispatchVal.replace("[", "\\[").replace("]", "\\]")
    [new RegExp("^" + dispatchVal + "$"), fns])

  (value, args...) -> 
    _this = ctx or @
    dispatchVal = dispatchFn.call(_this, value)
    _.chain(dispatch).filter(([key]) -> !_.isEmpty(dispatchVal.match(key)))
      .each(([key, fns]) -> 
        _.each(fns, (fn) -> fn.apply(_this, args.concat(value))))

U.pipeline = (fns...) -> 
  _this = @
  (seed, args...) ->
    _.reduce(fns, ((m, fn) -> 
      fn.call(_this, m, args...)
    ), seed)
