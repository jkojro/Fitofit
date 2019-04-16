require 'open-uri'
require 'uri'
require "dry/transaction"
require 'dry/monads/all'

class CountWalkDistanceService
  include Dry::Transaction
  include Dry::Monads

  step :validate_walk
  step :encode_locations
  step :parse_url
  step :get_response
  step :parse_response
  step :distance
  step :save_walk

  private

  def validate_walk(walk:)
    walk.valid? ? Success(walk: walk) : Failure('invalid address')
  end

  def encode_locations(walk:)
    locations = [URI.encode(walk.start_location), URI.encode(walk.end_location)]
    locations.second.is_a?(String) ? Success(walk: walk, locations: locations) : Failure
  end

  def parse_url(walk:, locations:)
    start, finish = locations
    url = URI.parse(
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start}&destinations=#{finish}\r\n
        &mode=walking&units=metric&key=#{Rails.application.credentials[:google_maps_api_key]}"
    )
    url ? Success(walk: walk, url: url) : Failure
  end

  def get_response(walk:, url:)
    response = open(url).read
    response ? Success(walk: walk, response: response) : Failure
  end

  def parse_response(walk:, response:)
    result_json = JSON.parse(response)
    result_json ? Success(walk: walk, result_json: result_json) : Failure
  end

  def distance(walk:, result_json:)
    m_distance = result_json['rows'].first['elements'].first['distance']['value'].to_f
    distance = (m_distance / 1000).round(2)
    distance.is_a?(Float) ? Success(walk: walk, distance: distance) : Failure
  end

  def save_walk(walk:, distance:)
    walk.distance = distance
    walk.save ? Success(walk: walk) : Failure
  end
end
