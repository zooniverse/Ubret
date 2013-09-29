class KeysSettings extends U.Setting
  template: require('./templates/keys')
  reqState: ['keys']
  optState: ['key']

  events: {
    'change select' : 'changeKey'
  }

  changeKey: (ev) ->
    @state.set(@optState[0], ev.target.value)

  render: (state) ->
    state.selKey = state[@optState[0]]
    super state

module.exports = KeysSettings