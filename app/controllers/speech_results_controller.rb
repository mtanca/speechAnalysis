class SpeechResultsController < ApplicationController
  include SpeechResultsHelper

  before_action :authenticate_user!, only: [:show, :index]

  def index
    user = User.find(params[:user_id])

    if authorized?(user)
      render json: user.speech_results.order(id: :desc), include: ['speech_result']
    else
      render json: { errors: "Forbidden" }, status: 403
    end
  end

  def show
    speech_result = SpeechResult.find(params[:id])

    if authorized?(speech_result.user)
        render json: speech_result, include: show_options
    else
      render json: { errors: "Forbidden" }, status: 403
    end
  end

  def create
    image_results = InterimResult.new(current_user.id).image_results
    speech_results = SpeechResult.new(speech_result_params)
    speech_results.user = current_user
    speech_results.save

    handle_results(speech_result, image_results)
  end


  protected
    def speech_result_params
      params.require(:speech_result).permit(:duration, :wpm, :user_id, :transcript)
    end

    def authorized?(user)
      user == current_user
    end
end
