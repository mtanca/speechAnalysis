require 'json'
require 'uri'
require 'net/http'

module ApplicationHelper
  def get_token
    token = ''
    uri = URI.parse(ENV["TOKEN_ENDPOINT_URI"])
    token = request_token(uri)

    render json: {token: token}
  end

  private
  def request_token(uri)
    Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new(uri)
        request.basic_auth ENV["WATSON_S2T_USER"], ENV["WATSON_S2T_PW"]
        token = http.request(request)
    end

    token.body
  end
end
