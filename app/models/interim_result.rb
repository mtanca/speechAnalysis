class InterimResult < ApplicationRecord
  belongs_to :user

  def initialize(user_id)
    @user_id = user_id
    @user = User.find(user_id)
    @denominator = @user.interim_results.count
  end

  def average(array)
    array.inject {|sum, n| sum + n}
  end

  def to_float
    (self * 100) / @denominator
  end


  def image_results()
    anger_average = average(@user.interim_results.map {|emotion| emotion.anger }).to_float
    happiness_average = average(@user.interim_results.map {|emotion| emotion.happiness }).to_float
    disgust_average = average(@user.interim_results.map {|emotion| emotion.disgust }).to_float
    sadness_average = average(@user.interim_results.map {|emotion| emotion.sadness }).to_float
    fear_average = average(@user.interim_results.map {|emotion| emotion.fear }).to_float
    contempt_average = average(@user.interim_results.map {|emotion| emotion.contempt }).to_float
    neutral_average = average(@user.interim_results.map {|emotion| emotion.neutral }).to_float
    surprise_average = average(@user.interim_results.map {|emotion| emotion.surprise }).to_float

    {anger_avg: anger_average, hapiness_avg: happiness_average, disgust_avg: disgust_average, sadness_avg: sadness_average, fear_avg: fear_average, contempt_avg: contempt_average, neutral_avg: neutral_average, surprise_avg: surprise_average}
  end
end
