class MessageBroadcastJob < ApplicationJob
  queue_as :default

  #perform will execute when perform_later method is called in message.rb
  def perform(message)
    sender = message.user
    recipient = message.conversation.opposed_user(sender)
    puts "************"
    puts "#{recipient.id}"
    puts "************"
    #connect with specified channel and send a conversation_id and a HTML code using a partial
    broadcast_to_sender(sender, message)
    broadcast_to_recipient(recipient, message)
  end

  private

  def broadcast_to_sender(user, message)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      command: 'new_message',
      message: render_message(message, user),
      conversation_id: message.conversation_id
    )
  end

  def broadcast_to_recipient(user, message)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      command: 'new_message',
      window: render_window(message.conversation, user),
      message: render_message(message, user),
      conversation_id: message.conversation_id
    )
  end

  #in Rails 5 we can render a HTML code from any partial or a view
  #by calling the ApplicationController.render method outside a controller
  def render_message(message, user)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message, user: user }
    )
  end

  #return conversation partial
  def render_window(conversation, user)
    ApplicationController.render(
      partial: 'conversations/conversation',
      locals: { conversation: conversation, user: user }
    )
  end


end


#What is a job? A job is a class which performs code by using Redis server and is not connected with a Rails server.
#It’s completely independant. It can create or update a record, call a model’s method, or do whatever you want!
