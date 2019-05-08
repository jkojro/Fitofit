require "dry/transaction"
require 'dry/monads/all'

class AssignWalkDistanceService
  include Dry::Transaction
  include Dry::Monads

  step :validate_walk
  step :encode_locations
  step :get_distance_matrix_result
  step :count_distance
  step :assign_distance

  private

  def validate_walk(walk:)
    walk.valid? ? Success(walk: walk) : Failure('invalid address')
  end

  def encode_locations(walk:)
    locations = [URI.encode(walk.start_location), URI.encode(walk.end_location)]
    locations.second.is_a?(String) ? Success(walk: walk, locations: locations) : Failure
  end

  def get_distance_matrix_result(walk:, locations:)
    DistanceMatrixResponseService.new.call(walk: walk, locations: locations)
  end

  def count_distance(walk:, result_json:)
    m_distance = result_json['rows'].first['elements'].first['distance']['value'].to_f
    distance = (m_distance / 1000).round(2)
    distance.is_a?(Float) ? Success(walk: walk, distance: distance) : Failure
  end

  def assign_distance(walk:, distance:)
    walk.distance = distance
    walk.distance ? Success(walk: walk) : Failure
  end
end
