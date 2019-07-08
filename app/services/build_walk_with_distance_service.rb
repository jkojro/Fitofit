class BuildWalkWithDistanceService < BaseService

  def initialize(walk)
    @walk = walk
  end

  def call
    # byebug
    validate_walk(@walk)
    locations = encode_locations(@walk)
    result_json = get_distance_matrix_result(@walk, locations)
    distance = count_distance(@walk, result_json)
    assign_distance(@walk, distance)
  end

  # step :validate_walk
  # step :encode_locations
  # step :get_distance_matrix_result
  # step :count_distance
  # step :assign_distance

  private

  def validate_walk(walk)
    walk.valid? ? success(walk) : failure('invalid address')
  end

  def encode_locations(walk)
    locations = [URI.encode(walk.start_location), URI.encode(walk.end_location)]
    locations.second.is_a?(String) ? success(locations) : failure
  end

  def get_distance_matrix_result(walk, locations)
    DistanceMatrixResponseService.new.call(walk: walk, locations: locations)
  end

  def count_distance(walk, result_json)
    m_distance = result_json['rows'].first['elements'].first['distance']['value'].to_f
    distance = (m_distance / 1000).round(2)
    distance.is_a?(Float) ? success(distance) : failure
  end

  def assign_distance(walk, distance)
    walk.distance = distance
    walk.distance ? success(walk) : failure
  end
end
