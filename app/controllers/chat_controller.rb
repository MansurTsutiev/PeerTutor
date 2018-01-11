class ChatController < ApplicationController
  def index
    #if conversations array doesn't exist, set conversations and point it to new array
    session[:conversations] ||= []


    tutoring_session = TutoringSession.where(user_id: current_user.id).or(TutoringSession.where(tutor_id: current_user.id)).last


    if !tutoring_session.nil? && tutoring_session.accepted
      @conversations = []
      @users = User.all.where(id: tutoring_session.user_id).or(User.all.where(id: tutoring_session.tutor_id)).where.not(id: current_user)                 #select all users that are not us
      #Includes method eager loads all the users and the associated messages
      #joins these 3 tables and returns rows with Conversation id specified
      @conversations << Conversation.includes(:recipient, :messages)
                                   .find_by(id: session[:conversations])
    end
  end
end
