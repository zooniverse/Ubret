KeysSetting = require('./keys')

class AxisKeySetting extends KeysSetting
  template: require('./templates/axis_key')
  axis: ''

  render: (state) ->
    state.axis = @axis
    super

module.exports = AxisKeySetting
