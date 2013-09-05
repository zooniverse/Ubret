class PageSetting extends U.Setting
  className: 'page-setting'
  template: require('./templates/page')
  reqState: ['currentPage']

  events: {
    'click button' : 'changePage'
  }

  changePage: (ev) ->
    @state.set('currentPage', parseInt(ev.target.dataset.page))

module.exports = PageSetting
