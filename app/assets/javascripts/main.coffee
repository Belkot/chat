current_chat_id = ''
refresh_chat = null

tickerOn = ->
  refresh_chat = setInterval ->
    loadMessages()
    makeAllUsersList()
    makeChatList()
  , 3000

tickerOff = ->
  clearInterval(refresh_chat)


$(document).ready ->
  $('#signModal').modal 'show'

  $('#signup_form, #signin_form').on('ajax:success', (e, data, status, xhr) ->
    $('#userName').text data.user.name
    $('#signModal').modal 'hide'
    makeChatList()
    tickerOn()
  ).on 'ajax:error', (e, xhr, status, error) ->
    $('#signModal').modal('show')
    errors = xhr.responseJSON.error
    $('#signup > ul').remove()
    $('#signup').append '<ul>'
    for message of errors
      $('#signup ul').append '<li>' + errors[message] + '</li>'

  $('#signout_link').on 'ajax:success', (e, data, status, xhr) ->
    $('#signModal').modal 'show'
    tickerOff()
    $('#session_password').val ''

  $('#chatsList').on 'ajax:success', (e, data, status, xhr) ->
    $('#chatName').text(data.chat.name)
    makeUsersList data.chat
    current_chat_id = data.chat.id
    url = '/chats/' + current_chat_id
    $('#messageForm').attr('action', url + '/messages.json')
    $('#markReadAll').attr('href', url + '/readall.json')
    $('#chatUpdateForm').attr('action', url + '.json')
    $('#chatUpdateForm #chat_name').val data.chat.name
    $('#chatUpdateForm #chat_user_ids').val data.chat.user_ids
    loadMessages()

  $('#messageForm').on 'ajax:success', (e, data, status, xhr) ->
    $('#message_text').val('')

makeChatList = ->
  $.ajax
    type: 'GET'
    url: '/chats.json'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      $('#chatsList').empty()
      for i in data
        newLI = $('<a/>').addClass('list-group-item').attr('href', '/chats/' + i.chat.id).attr('data-remote', true).text(i.chat.name).appendTo('#chatsList')
        $('<span/>').addClass('badge').text(i.chat.unread_messages_count).appendTo(newLI)
  scrollChatList()

scrollChatList = ->
  $('#chatBody').css({'height':'300px', 'overflow-y':'scroll'}) #style='min-height: 10; max-height: 10;

loadMessages = ->
  $.ajax
    type: 'GET'
    url: '/chats/' + current_chat_id + '/messages.json'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      makeMesagesList data

makeMesagesList = (messages) ->
  message_lines = ''
  for i in messages
    message_lines += i.message.create_time + ' - ' + i.message.user_name + ' : ' + i.message.text + '<br>'
  $('#chatBody').html message_lines

makeUsersList = (chat) ->
  user_lines = ''
  for id in chat.user_ids
    user_lines += id + '<br>'
  $('#collapseUserInChat > .panel-body').html user_lines

makeAllUsersList = ->
  $.ajax
    type: 'GET'
    url: '/users.json'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      user_lines = ''
      for i in data
        user_lines += i.user.id + ': ' + i.user.name + ' - ' + i.user.messages_count + ' messages.' + '<br>'
      $('#collapseUserAll > .panel-body').html user_lines
