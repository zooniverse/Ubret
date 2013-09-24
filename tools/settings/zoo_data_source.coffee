class ZooDataSourceSetting extends U.Setting
  className: "data-source-setting"
  template: require('./templates/zoo_data_source')
  reqState: ['zooDataCollections']
  optState: ['id']

  events: {
    'change select' : 'changeId'
  }

  changeId: (ev) ->
    id = parseInt(ev.target.value)
    collection = @state.get('zooDataCollections')[0][id]
    @state.set('user', collection.user)
    @state.set('id', id)

module.exports = ZooDataSourceSetting
