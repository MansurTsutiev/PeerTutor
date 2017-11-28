class TutoringSession < ApplicationRecord
  belongs_to :course
  belongs_to :user
  belongs_to :tutor, optional: true
end
