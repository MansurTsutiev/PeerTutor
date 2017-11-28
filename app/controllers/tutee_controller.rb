class TuteeController < ApplicationController

  before_action :authenticate_user!   ## User has to be logged in

  #new
  def find_tutor
    @tutoring_session = TutoringSession.where(user_id: current_user.id).last

    if @tutoring_session.nil? || @tutoring_session.tutor_id.nil?
      @subject = Subject.new
      respond_to do |format|
        format.js {render "find_tutor" }
      end
      #@courses = Course.all
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

    # @tutoring_session = TutoringSession.new
    # @tutoring_session.course_id = params[:course][:id].to_i
    # @tutoring_session.question = params[:tutoring_session][:question]
    # @tutoring_session.user_id = current_user.id
    # @tutoring_session.save()


    #  tutors = User.where(is_tutor: true).id
    #  tutors.each do
    @tutors = User.all
    respond_to do |format|
      format.js {render 'list_of_tutors'}
    end
  end

  def cancel_tutoring_session
    @tutor = User.find(params[:tutor_id])
    TutoringSession.where(user_id: current_user.id).last.destroy!
    ActionCable.server.broadcast(
      "conversations-#{@tutor.id}",
      command: "session_canceled",
      tutee_id: current_user.id
    )
    respond_to do |format|
      format.js {render 'find_tutor'}
    end
  end

  def list_of_tutors

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

  private
  #Strong Parameter
  def tutoring_session_params
    params.require(:tutoring_session).permit(:question).merge(
      user_id: current_user.id,
      course_id: params[:course][:id].to_i
    )
  end

end
