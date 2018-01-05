class TutorController < ApplicationController

  before_action :authenticate_user!   ## User has to be logged in

  def index
    #check if user is a tutor
    unless current_user.is_tutor
      redirect_to tutor_first_time_tutor_path
    end

    if current_user.is_live
      @tutoring_sessions = TutoringSession.where(tutor_id: current_user.id, accepted: false)
    else
      @not_live = true
    end
  end

  def incoming_requests
    if current_user.is_live
      @tutoring_sessions = TutoringSession.where(tutor_id: current_user.id, accepted: false)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render 'offline'}
      end
    end
  end

  def accept_request

    TutoringSession.find(params[:session_id]).update(accepted: true)

    tutoring_session = TutoringSession.find(params[:session_id])
    tutee_id = tutoring_session.user_id
    tutors = []
    tutors << User.find(tutoring_session.tutor_id)
    @tutee = User.find(tutoring_session.user_id)

    conversations = Conversation.where(recipient_id: tutors[0], sender_id: @tutee.id)

    #save location in a message
    tutee_name = User.find(tutee_id).first_name
    prompt1 = "Hey #{tutee_name}!\n"
    location = current_user.location
    prompt2 = "My location: #{location}"
    conversation = Conversation.create(sender_id: current_user.id, recipient_id: tutee_id)
    message = Message.create(body: prompt1, user_id: current_user.id, conversation_id: conversation.id)
    message = Message.create(body: prompt2, user_id: current_user.id, conversation_id: conversation.id)

    #Broadcast to tutee
    ActionCable.server.broadcast(
      "conversations-#{@tutee.id}",
      command: "tutor_accepted",
      tutor_response: ApplicationController.render(
        partial: 'tutor/temp',
        locals: {location: "", item2: "" }
      )
    )


    respond_to do |format|
      format.js {render 'chat/index'}
    end
  end

  def complete_tutoring_session
    @tutee = User.find(params[:user_id])
    @session_id = params[:session_id]
    TutoringSession.where(id: @session_id).last.destroy!
    ActionCable.server.broadcast(
      "conversations-#{@tutee.id}",
      command: "session_completed",
      tutor_id: current_user.id,
      tips_box: ApplicationController.render(partial: 'tutee/tips_management')
    )
    respond_to do |format|
      format.js {render 'incoming_requests'}
    end
  end

  def currently_tutoring
    @tutoring_sessions = TutoringSession.where(tutor_id: current_user.id, accepted: true)
    respond_to do |format|
      format.js
    end
  end

  def tutor_profile
    respond_to do |format|
      format.js
    end
  end

  def piggy_bank
    respond_to do |format|
      format.js
    end
  end

  def messenger
    respond_to do |format|
      format.js {render 'chat/index'}
    end
  end

  def first_time_tutor
    @subject = Subject.new
  end

  def get_courses
    render partial: 'select_course_tutor', locals: {subject_id: params[:subject_id]}
  end

  def get_tags
    render partial: 'course_tag_tutor', locals: {course_id: params[:course_id]}
  end

  def create
    #TutorCourse.create(tutor_course_params)

    # @tutor = Tutor.new
    # @tutor.user_id = current_user.id
    # @tutor.total_tip = 0;
    # @tutor.save()

    @user_tutor = User.find(current_user.id)
    @user_tutor.update_attributes(is_tutor: true)

    @tutor_courses = params[:course][:id]
    @tutor_courses.shift

    @tutor_courses.each do |course_id|
      TutorCourse.create(tutor_id: current_user.id, course_id: course_id.to_i)
    end

    redirect_to tutor_index_path
  end

  def toggle_is_live
    if current_user.is_live
      current_user.update_attributes(is_live: false)

      unless current_user.location.nil?
        current_user.update_attributes(location: nil)
      end

      respond_to do |format|
        format.js { render 'offline'}
      end
    else
      current_user.update_attributes(is_live: true)
      @tutoring_sessions = TutoringSession.where(tutor_id: current_user.id, accepted: false)
      respond_to do |format|
        format.js { render 'location'}
      end
    end
  end

  def add_location
    location = params[:location][:location]
    if current_user.update_attributes(location: location)
      respond_to do |format|
        format.js {render 'incoming_requests'}
      end
    else
      respond_to do |format|
        format.js {render 'offline'}
      end
    end
  end

  private

  def tutor_course_params

  end

end
