# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  showCommentForm = (e) ->
    e.preventDefault();
    $(this).hide();
    resourceId = $(this).data('resourceId')
    resourceType = $(this).data('resourceType')
    $("form#comment-for-#{resourceType}-#{resourceId}").show()

  createCommentSuccess = (e, xhr, status, error) ->
    $(this).hide()
    $('#comment_body').val('')
    $('.create-comment-link').show()

  createCommentError = (e, xhr, status, error) ->
    $('.create-comment-errors').html('')
    errors = $.parseJSON(xhr.responseText).errors.body
    $.each errors, (index, value) ->
      $('.create-comment-errors').append(value)

  subscribeToComment = () ->
    questionId = $('.question').data('questionId')
    channel = "/questions/#{questionId}/comments"
    PrivatePub.subscribe channel, (data, channel) ->
      comment = $.parseJSON(data['comment'])
      resource_type = comment.commentable_type.toLowerCase()
      $("##{resource_type}-comments").append(JST["templates/comment"]({comment: comment}))

  $(document).on 'ajax:success', 'form.new_comment', createCommentSuccess
  $(document).on 'ajax:error', 'form.new_comment', createCommentError
  $(document).on 'click', '.create-comment-link', showCommentForm
  $(document).ready subscribeToComment
