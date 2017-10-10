class TutoringSession < ApplicationRecord
  belongs_to :course
  belongs_to :user
  #belongs_to :tutor    #has not created tutor model
end
