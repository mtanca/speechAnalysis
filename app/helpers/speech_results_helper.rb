module SpeechResultsHelper
  ALECHEMY_OPTIONS = {
    apikey: ENV["WATSON_API_KEY"],
    verify_ssl: OpenSSL::SSL::VERIFY_NONE
  }.freeze

  def parse_tone_result(array, target)
    array.map {|tone| target.write_attribute(tone["tone_name"].downcase.split.join('_').to_sym, tone["score"])}
  end

  def get_tone(text)
    TONE_ENDPOINT_SUFFIX = "@gateway.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19&text="
    tone_endpoint = "https://#{ENV["WATSON_TONE_USER"]}:#{ENV["WATSON_TONE_PW"]}#{TONE_ENDPOINT_SUFFIX}#{text}"

    JSON.parse(RestClient.get(tone_endpoint))
  end

  def get_alchemy_results(text)
    results = {}
    results["taxonomies"] = taxonomy_results(text)
    results["keywords"] = keyword_results(text)

    results
  end

  def taxonomy_results(text)
    service = WatsonAPIClient::AlchemyLanguage.new(ALECHEMY_OPTIONS)
    response = service.TextGetRankedTaxonomy_get(text: text, outputMode:"json")
    result = JSON.parse(result.body)

    result["taxonomy"]
  end

  def keyword_results(text)
    KEYWORD_OPTIONS = {
      text: text,
      apikey: ENV["WATSON_API_KEY"],
      outputMode: 'json',
      sentiment: 1,
      emotion: 1
    }.freeze

    keyword_endpoint = "https://gateway-a.watsonplatform.net/calls/text/TextGetRankedKeywords"
    results = JSON.parse(RestClient.post(keyword_endpoint, KEYWORD_OPTIONS).body)

    results["keywords"]
  end

  def handle_results(speech_result, image_results)
    if speech_result.generate_analysis(speech_result.transcript.gsub(/\P{ASCII}/, "")) && speech_result.keywords.any?
      add_image_results(speech_result, image_results)

      render json: speech_result, include: create_options
    else
      speech_result.destroy

      render json: { errors: "Forbidden" }, status: 403
    end
  end

  def add_image_results(speech_result, image_results)
    speech_result.image_emotions = {
      anger: users_image_results[:anger_avg],
      contempt: users_image_results[:contempt_avg],
      disgust: users_image_results[:disgust_avg],
      fear: users_image_results[:fear_avg],
      happiness: users_image_results[:happiness_avg],
      neutral: users_image_results[:neutral_avg],
      surprise: users_image_results[:surprise_avg],
    }
  end

  def create_options
    [:user, :doc_emotion, :doc_language_tone, :doc_social_tone, :taxonomies, :keywords, :image_emotions]
  end

  def show_options
    [:user, :doc_emotion, :doc_language_tone, :doc_social_tone, :taxonomies, :keywords]
  end
end
