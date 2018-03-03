class HomeController < ApplicationController

  before_action :authenticate_user!, only: :authentication
  def index
  	@header_text = "Save your peers from the struggles of school. Become a tutor."
  	@step_one = "Need help with your studies?"
  	@step_two = "Find a tutor on campus with Peer Tutoring"
  	@step_three = "Learn from your own peers!"
  end

  def authentication
    if current_user.is_tutor
      current_user.update_attributes(is_live: false, location: nil)
    end
  end
end
