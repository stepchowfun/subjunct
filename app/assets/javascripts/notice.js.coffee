window.NoticeController = ($scope, $sce) ->
  $scope.notices = []

  window.notice = (message) ->
    $scope.$apply () ->
      $scope.notices.push({
        text: $sce.trustAsHtml(message),
        open: true,
      })

NoticeController.$inject = ['$scope', '$sce']
