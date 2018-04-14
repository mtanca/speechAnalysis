module InterimResultsHelper
  def decode_image(image)
    Base64.decode64(image['data:image/png;base64,'.length .. -1])
  end

  def get_image_scores(image_data)
    uri = create_uri()
    request = build_request(uri.request_uri, image_data)
    results = send_request(request)

    results[0]["scores"]
  end

  def create_uri
    uri = URI('https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize')
    uri.query = URI.encode_www_form({})

    uri
  end

  def build_request(request_uri, payload)
    init_request = Net::HTTP::Post.new(request_uri)
    request_with_headers = set_request_headers(init_request)

    request_with_headers_and_body = set_request_body(request_with_headers, payload)
  end

  def set_request_headers(request)
    request['Content-Type'] = 'application/octet-stream'
    request['Ocp-Apim-Subscription-Key'] = ENV["EMOTION_KEY"]

    request
  end

  def set_request_body(request, payload)
    request.body = payload.to_s

    request
  end

  def send_request(request)
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
