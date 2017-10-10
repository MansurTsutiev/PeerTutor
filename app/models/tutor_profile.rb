class TutorProfile < ApplicationRecord
  belongs_to :users
  has_and_belongs_to_many :courses
  has_one :schedule
end
