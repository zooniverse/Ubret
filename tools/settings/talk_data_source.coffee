class TalkDataSourceSetting extends U.Setting
  className: "data-source-setting"
  template: require('./templates/talk_data_source')
  reqState: ['talkCollections'] 
  optState: ['params.talk-collection']

  events: {
    'change select' : 'changeCollection'
  }

  changeCollection: (ev) ->
    @state.set('params', {
      "type": "talk-collection",
      "talk-collection": ev.target.value
    })

module.exports = TalkDataSourceSetting
