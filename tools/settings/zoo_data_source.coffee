class ZooDataSourceSetting extends U.Setting
  className: "data-source-setting"
  template: require('./templates/zoo_data_source')
  reqState: ['zooDataCollections']
  optState: ['id']

  events: {
    'change select' : 'changeId'
  }

  changeId: (ev) ->
    @state.set('id', parseInt(ev.target.value))

module.exports = ZooDataSourceSetting
