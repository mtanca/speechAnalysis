class ImageEmotionSerializer < ActiveModel::Serializer
  attributes :anger, :fear, :sadness, :surpise, :disgust, :contempt, :neutral
end
