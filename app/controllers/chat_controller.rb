class ChatController < ApplicationController
  def index
    #if conversations array doesn't exist, set conversations and point it to new array
    session[:conversations] ||= []


    tutoring_sessions = TutoringSession.where(user_id: current_user.id).or(TutoringSession.where(tutor_id: current_user.id))


    if tutoring_sessions.count > 1
      #tutor
      @conversations = []

      user_ids = TutoringSession.where(tutor_id: current_user.id).pluck(:user_id)
      @users = User.find(user_ids)

      @conversations << Conversation.includes(:recipient, :messages).find_by(id: session[:conversations])
    elsif tutoring_sessions.count == 1
      #tutee
      tutoring_session = tutoring_sessions[0]
      if !tutoring_session.nil? && tutoring_session.accepted
        @conversations = []
        @users = User.all.where(id: tutoring_session.user_id).or(User.all.where(id: tutoring_session.tutor_id)).where.not(id: current_user)                 #select all users that are not us
        #Includes method eager loads all the users and the associated messages
        #joins these 3 tables and returns rows with Conversation ids (array of id's) specified
        @conversations << Conversation.includes(:recipient, :messages)
                                     .find_by(id: session[:conversations])
      end
    end
  end #end index
end #end class
