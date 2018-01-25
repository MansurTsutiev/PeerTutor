class TuteeController < ApplicationController

  before_action :authenticate_user!   ## User has to be logged in

  def index
    @tutoring_session = TutoringSession.where(user_id: current_user.id).last

    if @tutoring_session.nil?
      @subject = Subject.new
      @command = "find_tutor"
    elsif @tutoring_session.tutor_id.nil? ## if the session created but tutee hasn't picked tutors yet
      available_tutors(@tutoring_session.course_id)
      @command = "list_of_tutors"
    elsif @tutoring_session.accepted
      @tutor = User.find(@tutoring_session.tutor_id)
      @command = "being_tutored"
    else
      @tutor = User.find(@tutoring_session.tutor_id)
      @command = "pick_tutor"
    end

  end

  #new
  def find_tutor
    @tutoring_session = TutoringSession.where(user_id: current_user.id).last

    if @tutoring_session.nil?
      @subject = Subject.new
      respond_to do |format|
        format.js {render "find_tutor" }
      end
      #@courses = Course.all
    elsif @tutoring_session.tutor_id.nil? ## if the session created but tutee hasn't picked tutors yet
      available_tutors(@tutoring_session.course_id)
      respond_to do |format|
        format.js {render 'list_of_tutors'}
      end
    elsif @tutoring_session.accepted
      @tutor = User.find(@tutoring_session.tutor_id)
      #render 'being_tutored', locals: { tutoring_session: @tutoring_session, tutor: @tutor}
      respond_to do |format|
        format.js {render "being_tutored"}
      end
    else
      @tutor = User.find(@tutoring_session.tutor_id)
      respond_to do |format|
        format.js {render "pick_tutor"}
      end
    end
  end

  def get_courses
    render partial: 'select_course', locals: {subject_id: params[:subject_id]}
  end

  #create
  def create
    TutoringSession.create(tutoring_session_params)

    @tutoring_session = TutoringSession.where(user_id: current_user.id).last
    available_tutors(@tutoring_session.course_id)
    respond_to do |format|
      format.js {render 'list_of_tutors'}
    end
  end

  def cancel_tutoring_session
    if !params[:tutor_id].present?
      TutoringSession.where(user_id: current_user.id).last.destroy!
      render 'find_tutor'
    else
      @tutor = User.find(params[:tutor_id])
      TutoringSession.where(user_id: current_user.id).last.destroy!
      Conversation.where(recipient_id: current_user.id, sender_id: @tutor.id).or(Conversation.where(recipient_id: @tutor.id, sender_id: current_user.id)).last.destroy
      ActionCable.server.broadcast(
        "conversations-#{@tutor.id}",
        command: "session_canceled",
        tutee_id: current_user.id
      )
      respond_to do |format|
        format.js {render 'find_tutor'}
      end
    end
  end

  def being_tutored
    @tutoring_session = TutoringSession.where(user_id: current_user.id, accepted: true).last
    @tutor = User.where(id: @tutoring_session.tutor_id).last
    respond_to do |format|
      format.js
    end
  end

  def list_of_tutors
    @tutoring_session = TutoringSession.where(user_id: current_user.id).last

    available_tutors(@tutoring_session.course_id)
    respond_to do |format|
      format.js {render 'list_of_tutors'}
    end
  end

  def pick_tutor
    @tutor = User.find(params[:tutor_id])
    TutoringSession.where(user_id: current_user.id).last.update(tutor_id: @tutor.id)
    tutoring_sessions = TutoringSession.where(user_id: current_user.id)
    #Inform tutor
    ActionCable.server.broadcast(
      "conversations-#{@tutor.id}",
      command: "tutor_picked",
      tutoring_session: ApplicationController.render(partial: 'tutor/tutoring_sessions', locals: {tutoring_sessions: tutoring_sessions, })
    )
  end

  def cancel_tutor
    @tutor = User.find(params[:tutor_id])
    TutoringSession.where(user_id: current_user.id).last.update(tutor_id: nil, accepted: false)
    ActionCable.server.broadcast(
      "conversations-#{@tutor.id}",
      command: "session_canceled",
      tutee_id: current_user.id
    )
    respond_to do |format|
      format.js {render inline: "location.reload();"}
    end
  end


  def tips_management
    respond_to do |format|
      format.js
    end
  end

  def schedule
    respond_to do |format|
      format.js
    end
  end

  def tutoring_sessions
    @tutoring_sessions = TutoringSession.all
  end

  def profile
    @tutee = User.find(current_user.id)
    respond_to do |format|
      format.js
    end
  end

  private
  #Strong Parameter
  def tutoring_session_params
    params.require(:tutoring_session).permit(:question).merge(
      user_id: current_user.id,
      course_id: params[:course][:id].to_i
    )
  end

  def available_tutors(course_id)
    @tutors = User.where(is_tutor: true, is_live: true).where.not(id: current_user.id, location: nil).all  # @tutors.ids returns the array of live_tutor's ids

    course_tutor_ids = Array.new

    @tutors.each do |d|
      @course_tutor = TutorCourse.where(tutor_id: d, course_id: course_id.to_i).first
      if !@course_tutor.nil?
        course_tutor_ids << User.find(@course_tutor.tutor_id)
      else
      end
    end
    @available_tutors = course_tutor_ids

  end

end
