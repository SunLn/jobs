angular.module 'QiniuTopMenu',[]

# .factory 'menuService', ($q,$http)->

  # @getProduct = ()->
  #   $q (resove ,reject)->
  #     $http.jsonp 'http://localhost:9010/api/callback2?callback=JSON_CALLBACK&name=pd@qiniu.com'
  #     .then (data)->
  #       console.log data
  #     , (data)->
  #       console.log data

#   # return @

#.config ($sceDelegateProvider) ->
#  $sceDelegateProvider.resourceUrlWhitelist [
##     # Allow same origin resource loads.
#    'self'
##     # Allow loading from our assets domain.  Notice the difference between * and **.
##     'http*://*.qiniu.io/**'
##     'https://*.qiniu.com/**'
##     'https://*.qiniu.io/**'
##     'http*://localhost:9011/**'
#  ]

.directive 'qiniuMenu', ($state, $sce , $interval, localStorageService) ->
  restrict: 'E'
  scope: {}
    # 'gaeaHost': '=gaea'
  # }
  template: '
    <div id="main-navbar" class="navbar qiniu-main-navbar" role="navigation">
        <button type="button" id="main-menu-toggle" ng-show="isShowToggleBtn">
          <i class="navbar-icon fa fa-bars icon"></i>
          <span class="hide-menu-text">&nbsp;隐藏菜单</span>
        </button>
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed  pull-left" data-toggle="collapse" data-target="#main-navbar-collapse"><i class="navbar-icon fa fa-bars"></i></button>

          <a href="/" class="navbar-brand pull-left">
            <div><img alt="七牛开发者平台" ng-src="{{logoUrl}}"></div>
          </a>
          <ul class="nav navbar-nav pull-left right-navbar-nav">
            <li dropdown id="product-dropdown" class="dropdown" ng-show="!isSignInPage">
              <a href="" class="dropdown-toggle user-menu" dropdown-toggle>
                <i class="fa fa-th-large"></i>
                选择服务
              </a>
              <div class="dropdown-menu">
                <iframe class="product" ng-if="gaeaHost" ng-src="{{productUrl}}" frameborder="0" id="product-iframe"></iframe>
              </div>
            </li>
          </ul>
        </div>
        <div id="main-navbar-collapse" class="collapse navbar-collapse main-navbar-collapse">
            <div class="right clearfix">
              <ul class="nav navbar-nav pull-right right-navbar-nav" ng-show="!isSignInPage">
                <li dropdown class="nav-icon-btn nav-icon-btn-success dropdown">
                  <a class="dropdown-toggle" dropdown-toggle>
                    <span class="label">
                      10
                    </span>
                    <i class="nav-icon fa fa-bell"></i>
                    <span class="small-screen-text">我的信息</span>
                  </a>
                  <div class="dropdown-menu widget-messages-alt message-box" special-dropdown>
                    <div class="arrow-up"></div>

                    <iframe ng-src="{{messageUrl}}" ng-if="gaeaHost" frameborder="0" id="message-iframe"></iframe>
                  </div>
                </li>
                <li>
                  <a target="_blank" href="https://support.qiniu.com/tickets">
                    <i class="fa fa-headphones"></i>
                    工单列表
                  </a>
                </li>
                <li dropdown id="user-dropdown" class="dropdown" ng-show="!isSignInPage">
                  <a href="" class="dropdown-toggle user-menu" dropdown-toggle>
                    <img class="nav-avatar" ng-src="{{avatarUrl}}" alt="">
                  </a>
                  <div class="dropdown-menu ui-menu">
                    <iframe ng-src="{{userCardUrl}}" ng-if="gaeaHost" frameborder="0" id="user-card-iframe"></iframe>
                  </div>
                </li>
              </ul>
            </div>
        </div>
    </div>'
  link: (scope, element, attrs) ->

    # userService.setAvatar() # 设置用户头像


    scope.isSignInPage =  $state.current.name is 'layout.signin' #signin 页面隐藏 dropdown 入口
    scope.isShowToggleBtn =  attrs.showToogleBtn is 'true'

    scope.logoUrl = attrs.logoUrl
    element.find('#main-navbar').addClass attrs.menuTheme

    scope.gaeaHost =  scope.gaeaHost  || 'http://localhost:9011'
    scope.getProductUrl = ()->
      return  scope.gaeaHost + '/#/product'

    scope.getUserCardUrl = ()->
      return scope.gaeaHost + '/#/user-card'

    scope.getMessageUrl = ()->
      return scope.gaeaHost + '/#/user-message'

    scope.getMessageNumUrl = ()->
      return scope.gaeaHost + '/#/message-num'


    acchost = attrs.accoutHost || 'http://localhost:9010'
    # scope.productUrl = $sce.trustAsResourceUrl acchost + '/#/product'
    # scope.userCardUrl = $sce.trustAsResourceUrl acchost + '/#/user-card'
    # scope.messageUrl = $sce.trustAsResourceUrl acchost + '/#/user-message'
    # scope.messageNumUrl = $sce.trustAsResourceUrl acchost + '/#/message-num'

    # scope.$watch 'gaeaHost', ->
    #   return false if scope.gaeaHost is undefined

.filter 'trustUrl', ($sce) ->
  return (url) ->
    return $sce.trustAsResourceUrl url

.directive 'specialDropdown', ()->
  link : ($scope, $element, $attrs)->
    $element.on 'click', (e)->
      e.stopPropagation()

    $element.find('iframe').on 'mousewheel DOMMouseScroll', (ev)->
      $this = $(this)
      scrollTop = this.scrollTop
      scrollHeight = this.scrollHeight
      clientHeight = this.clientHeight
      height = $this.height()
      delta = if ev.type is 'DOMMouseScroll' then ev.originalEvent.detail * -40  else ev.originalEvent.wheelDelta
      up = delta > 0

      prevent = ()->
        ev.stopPropagation()
        ev.preventDefault()
        ev.returnValue = false
        return false

      if !up && scrollHeight - scrollTop is clientHeight
          # Scrolling down, but this will take us past the bottom.
          $this.scrollTop(scrollTop)
          return prevent()
      else if up && scrollTop is 0
          # Scrolling up, but this will take us past the top.
          $this.scrollTop(0)
          return prevent()

      return true

    return
