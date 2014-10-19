index = angular.module('post', [])

index.controller('PostController', ['$scope', '$sce', 'ajax', ($scope, $sce, ajax) ->
  $scope.post = post
  $scope.post.question = $sce.trustAsHtml($scope.post.question)
  $scope.post.expanded = false
  $scope.post.answered = false
  $scope.post.attempted = false
  $scope.post.attempted_answer = ''
  $scope.post.message = ''
  $scope.post.form_submitted = false

  $('.answer').focus()

  $scope.button_submit = (event) ->
    setTimeout (() -> $scope.submit(event)), 0

  $scope.submit = (event) ->
    if !$scope.post.form_submitted
      $scope.post.form_submitted = true
      ajax {
        url: '/check/+' + post.id,
        type: 'post',
        data: { answer: post.attempted_answer },
        success: ((data) ->
          $scope.$apply ->
            post.answered = true
            post.answer = $sce.trustAsHtml(data.answer)
            post.message = $sce.trustAsHtml(data.message)
        ),
        complete: (() ->
          $scope.$apply () ->
            $scope.post.form_submitted = false
            post.attempted = true
        ),
      }
])
