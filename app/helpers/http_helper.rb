module HttpHelper
  CONNECTION_ERRORS = [
    Timeout::Error, Errno::ECONNRESET, Errno::ECONNREFUSED,
    Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
  ].freeze
end
