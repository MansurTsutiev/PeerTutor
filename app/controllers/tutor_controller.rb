class TutorController < ApplicationController

  before_action :authenticate_user!   ## User has to be logged in

  def index
    #check if user is a tutor
    unless current_user.is_tutor
      redirect_to tutor_first_time_tutor_path
    end

    @tutoring_sessions = TutoringSession.where(tutor_id: current_user.id, accepted: false)
  end

  def incoming_requests
<<<<<<< HEAD
    # all the tutor's requests
    @my_tutoring_requests = TutoringSession.where(:tutor_id => current_user.id)
    # the tutor request's requested course information
    # @course_number = Course.where(:id => @my_tutoring_requests.course_id)
=======
    @tutoring_sessions = TutoringSession.where(tutor_id: current_user.id, accepted: false)
    respond_to do |format|
      format.js
    end
  end

  def accept_request
    TutoringSession.find(params[:session_id]).update(accepted: true)

    tutoring_session = TutoringSession.find(params[:session_id])
    tutor = User.find(tutoring_session.tutor_id)
    @tutee = User.find(tutoring_session.user_id)
    #Broadcast to tutee
    ActionCable.server.broadcast(
      "conversations-#{@tutee.id}",
      command: "tutor_accepted",
      being_tutored: ApplicationController.render(partial: 'tutee/being_tutored', locals: {tutoring_session: tutoring_session, tutor: tutor })
    )


    respond_to do |format|
      format.js
    end
>>>>>>> d872029796b19e8b1c2e6140dbf85da30eeb0095
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

  def is_live
    @tutor = Tutor.where(user_id: current_user.id).take
    if @tutor.is_live
      redirect_to tutor_incoming_requests_path
    end
  end

  def toggle_is_live
    @tutor = Tutor.where(user_id: current_user.id).take
    if @tutor.is_live
      @tutor.update_attribute(:is_live, false)
      #redirect_to tutor_is_live_path
      #respond with ajax
      
    else
      @tutor.update_attribute(:is_live, true)
      #redirect_to tutor_incoming_requests_path
      # respond_to do |format|
      #   format.js
      # end
    end
  end

  def first_time_tutor
<<<<<<< HEAD
    if current_user.is_tutor
      redirect_to tutor_index_path
    end
  end

  def update
    ##creates a new tutor record
    @new_tutor = Tutor.new(:user_id => current_user.id)
    @new_tutor.save
    ##udates the user's is_tutor
    @user = current_user
    @user.update_attribute(:is_tutor, true)
=======
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
    @tutor = Tutor.new
    @tutor.user_id = current_user.id
    @tutor.total_tip = 0;
    @tutor.save()

    @user_tutor = User.find(current_user.id)
    @user_tutor.update_attributes(is_tutor: true)


    @tutor_courses = params[:course][:id]
    @tutor_courses.shift

    @tutor_courses.each do |course_id|
      TutorCourse.create(tutor_id: current_user.tutor.id, course_id: course_id.to_i)
    end



>>>>>>> d872029796b19e8b1c2e6140dbf85da30eeb0095
    redirect_to tutor_index_path
  end

  # def update
  #   @tutor = current_user
  #   @tutor.update_attributes(is_tutor: true)
  #   redirect_to tutor_index_path
  # end

  private

  def tutor_course_params

  end

end
