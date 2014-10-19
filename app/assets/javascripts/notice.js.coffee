notice = angular.module('notice', [])

scope = null

notice.controller('NoticeController', ['$scope', ($scope) ->
  scope = $scope
  scope.notices = []
])

notice.factory('notice', ['$sce', ($sce) ->
  return (message) ->
    scope.$apply () ->
      scope.notices.push({
        text: $sce.trustAsHtml(message),
        open: true,
      })
])