require 'open-uri'
require 'uri'

class Walk < ApplicationRecord
  validates :start_location, :end_location, presence: true
  validate :start_different_form_end
  validates_format_of :start_location, :end_location,
    with: /\A^[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)* \d+, [A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)*, [A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+( +[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+)*\z/
  belongs_to :user

  before_save :calculate_distance

  private

  def calculate_distance
    start = URI.encode(start_location)
    finish = URI.encode(end_location)
    url = URI.parse(
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start}&destinations=#{finish}&mode=walking&units=metric&key=#{Rails.application.credentials[:google_maps_api_key]}"
    )
    response = open(url).read
    result = JSON.parse(response)
    m_distance = result["rows"].first["elements"].first["distance"]["value"].to_f
    self.distance = (m_distance/1000).round(2)
  end

  def start_different_form_end
    errors.add(:password, "End point can't be the same as Start point") if start_location == end_location
  end
end
