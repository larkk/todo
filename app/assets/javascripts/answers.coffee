# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  editAnswer = (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("form#edit-answer-#{answer_id}").show()

  createAnswerSuccess = (e, xhr, status, error) ->
    $('#create-answer-body').val('')

  createAnswerError = (e, xhr, status, error) ->
    $('.answer-errors').html('')
    errors = $.parseJSON(xhr.responseText).errors.body
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)

  editAnswerSuccess = (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $("#answer-#{answer.id}").replaceWith(JST["templates/answer"]({answer: answer}))

  editAnswerError = (e, xhr, status, error) ->
    $('.edit-answer-errors').html('')
    errors = $.parseJSON(xhr.responseText).errors.body
    $.each errors, (index, value) ->
      $('.edit-answer-errors').append(value)

  updateVotes = (e, data, status, xhr) ->
    resource = $.parseJSON(xhr.responseText)
    $("#answer-#{resource.id} .votes").replaceWith(JST["templates/votes"]({resource: resource}))

  subscribeToAnswers = ()->
    questionId = $('.question').data('questionId')
    channel = "/questions/#{questionId}/answers"
    PrivatePub.subscribe channel, (data, channel) ->
      answer = $.parseJSON(data['answer'])
      $('.answers').append(JST["templates/answer"]({answer: answer}))

  $(document).on 'click', '.edit-answer-link', editAnswer
  $(document).on 'ajax:success', 'form.new_answer', createAnswerSuccess
  $(document).on 'ajax:error', 'form.new_answer', createAnswerError
  $(document).on 'ajax:success', 'form.edit_answer', editAnswerSuccess
  $(document).on 'ajax:error', 'form.edit_answer', editAnswerError
  $(document).on 'ajax:success', '.answers', updateVotes
  $(document).ready subscribeToAnswers


