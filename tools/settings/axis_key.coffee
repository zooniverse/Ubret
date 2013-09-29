class AxisKeySetting extends U.Setting
  template: require('./templates/axis_key')
  reqState: ['axisKeys']

  axis: ''

  events: {
    'change select' : 'changeKey'
  }

  changeKey: (ev) ->
    @state.set(@optState[0], ev.target.value)

  render: (state) ->
    state.axis = @axis
    state.selKey = state[@optState[0]]
    super state

module.exports = AxisKeySetting
