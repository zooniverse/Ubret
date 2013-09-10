class DataSourceSetting extends U.Setting
  className: "data-source-setting"
  template: require('./templates/data_source')
  reqState: ['talk-collections'] 
  optState: ['params.talk-collection']

  events: {
    'change select' : 'changeCollection'
  }

  changeCollection: (ev) ->
    @state.set('params.talk-collection', ev.target.value)

module.exports = DataSourceSetting
