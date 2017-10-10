class Course < ApplicationRecord
  has_and_belongs_to_many :tutor_profiles
end
