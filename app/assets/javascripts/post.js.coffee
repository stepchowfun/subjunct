window.PostController = ($scope, $sce) ->
  $scope.post = post
  $scope.post.question = $sce.trustAsHtml($scope.post.question)
  $scope.post.expanded = false
  $scope.post.answered = false
  $scope.post.attempted = false
  $scope.post.attempted_answer = ''
  $scope.post.message = ''

  $(".answer").focus()

  $scope.button_submit = (event) ->
    setTimeout (() -> $scope.submit(event)), 0

  $scope.submit = (event) ->
    $.post("/check/+" + post.id, { answer: post.attempted_answer }).done (data) ->
      $scope.$apply () ->
        post.attempted = true
        if data.status == "ok"      
          post.answered = true
          post.answer = $sce.trustAsHtml(data.answer)
          post.message = $sce.trustAsHtml(data.message)

PostController.$inject = ['$scope', '$sce']
