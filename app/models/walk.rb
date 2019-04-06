class Walk < ApplicationRecord
  validates :start_location, :end_location, :distance, presence: true
  validate :start_different_form_end
  validates_format_of :start_location, :end_location,
    with: /\A^[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)* \d+, [A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)*, [A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)*\z/

  before_save :calculate_distance

  private

  def calculate_distance
    start, finish = coordinates
    self.distance = Geocoder::Calculations.distance_between(start, finish, units: :km).round(2)
  end

  def coordinates
    [Geocoder.coordinates(start_location), Geocoder.coordinates(end_location)]
  end

  def start_different_form_end
    errors.add(:password, "End point can't be the same as Start point") if start_location == end_location
  end
end
