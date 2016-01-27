json.partial! @chat
# json.chat do
#   json.id @chat.id
#   json.name @chat.name
#   json.user_ids @chat.user_ids
#   json.unread_messages_count @chat.unread_messages_count(current_user)
# end
json.messages @chat.messages do |message|
  json.id message.id
  json.text message.text
  json.create_time message.create_time
  json.user_name message.user.name
end
