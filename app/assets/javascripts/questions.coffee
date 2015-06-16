# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  editQuestion = (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $("form#edit-question-#{question_id}").show()

  updateVotes = (e, data, status, xhr) ->
    resource = $.parseJSON(xhr.responseText)
    $(".question .votes").replaceWith(JST["templates/votes"]({resource: resource}))

  subscribeToQeustions = () ->
    channel = '/questions'
    PrivatePub.subscribe channel, (data, channel) ->
      question = $.parseJSON(data['question'])
      $('.questions').append(JST["templates/question"]({question: question}))


  $(document).on 'click', '.edit-question-link', editQuestion
  $(document).on 'ajax:success', '.question', updateVotes
  $(document).ready subscribeToQeustions
