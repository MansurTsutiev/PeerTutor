class Subject < ApplicationRecord
  has_many :courses

  def abbrev_and_name
    self.abbrev + ' - ' + self.name
  end
end
