class Course < ApplicationRecord
  belongs_to :subject
  has_many :tutoring_sessions

end
