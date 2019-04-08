class Walk < ApplicationRecord
  validates :start_location, :end_location, presence: true
  validate :start_different_form_end
  validates_format_of :start_location, :end_location,
    with: /\A^[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)* \d+, [A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)*, [A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)*\z/
  belongs_to :user

  before_save :calculate_distance

  private

  def calculate_distance
    CountWalkDistanceService.new(self).call
  end

  def start_different_form_end
    errors.add(:password, "End point can't be the same as Start point") if start_location == end_location
  end
end
