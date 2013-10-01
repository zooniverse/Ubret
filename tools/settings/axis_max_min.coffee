class AxisMinMaxSetting extends U.Setting
  template: require('./templates/axis_min_max')
  reqState: ['keys']

  axis: ''

  events: {
    'change .min' : 'setMin'
    'change .max' : 'setMax'
  }

  setMin: (ev) -> 
    value = (parseFloat(ev.target.value))
    @state.set(@optState[0], if isFinite(value) then value else null)

  setMax: (ev) ->
    value = (parseFloat(ev.target.value))
    @state.set(@optState[1], if isFinite(value) then value else null)

  render: (state) ->
    state.axis = @axis
    state.min = state[@optState[0]]
    state.max = state[@optState[1]]
    super state

module.exports = AxisMinMaxSetting
