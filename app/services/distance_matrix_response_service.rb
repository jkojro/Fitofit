class DistanceMatrixResponseService
  include Dry::Transaction
  include Dry::Monads

  step :parse_url
  step :get_response
  step :parse_response

  private

  def parse_url(walk:, locations:)
    start, finish = locations
    distance_matrix_url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{start}&destinations=#{finish}\r\n
        &mode=walking&units=metric&key=#{Rails.application.credentials[:google_maps_api_key]}"
    url = URI.parse(distance_matrix_url)
    url ? Success(walk: walk, url: url) : Failure
  end

  def get_response(walk:, url:)
    response = open(url).read
    response ? Success(walk: walk, response: response) : Failure
  rescue *HttpHelper::CONNECTION_ERRORS => error
    walk.errors.add(:base, error.message)
    failure(walk)
  end

  def parse_response(walk:, response:)
    result_json = JSON.parse(response)
    result_json['rows'].first['elements'].first['status'] == 'OK' ? Success(walk: walk, result_json: result_json) : Failure
  end
end
