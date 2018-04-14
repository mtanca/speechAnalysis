class InterimResultsController < ApplicationController
  include InterimResultsHelper
  before_action :authenticate_user!, only: [:show, :index]

  def create
    image_data = decode_image(params[:image])
    scores = get_image_scores(image_data)

    interim_result = InterimResult.new(scores)
    interim_result.user_id = current_user.id
    interim_result.save
  end
end
