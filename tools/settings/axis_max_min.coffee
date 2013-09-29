class AxisMinMaxSetting extends U.Setting
  template: require('./templates/axis_min_max')
  reqState: ['axisKeys']

  axis: ''

  events: {
    'change .min' : 'setMin'
    'change .max' : 'setMax'
  }

  setMin: (ev) -> 
    @state.set(@optState[0], parseFloat(ev.target.value))

  setMax: (ev) ->
    @state.set(@optState[1], parseFloat(ev.target.value))

  render: (state) ->
    state.axis = @axis
    state.min = state[@optState[0]]
    state.max = state[@optState[1]]
    super state

module.exports = AxisMinMaxSetting
