require 'open-uri'
require 'uri'

class CountWalkDistanceService
  def initialize(walk)
    @walk = walk
  end

  def call
    url = parse_url(encoded_locations)
    result = response_result(url)
    @walk.distance = distance(result)
  end

  def encoded_locations
    [URI.encode(@walk.start_location), URI.encode(@walk.end_location)]
  end

  def parse_url(locations)
    start, finish = locations
    URI.parse(
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start}&destinations=#{finish}&mode=walking&units=metric&key=#{Rails.application.credentials[:google_maps_api_key]}"
    )
  end

  def response_result(url)
    response = open(url).read
    JSON.parse(response)
  end

  def distance(result)
    m_distance = result['rows'].first['elements'].first['distance']['value'].to_f
    (m_distance / 1000).round(2)
  end
end
