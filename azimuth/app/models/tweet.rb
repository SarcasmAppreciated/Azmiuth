class Tweet < ActiveRecord::Base
  belongs_to :user
  validates :tweet_id, :time_stamp, :latitude, :longitude,  :presence => true 
  validates :tweet_id, uniqueness: true
  validates :latitude, :inclusion => -90..90
  validates :longitude, :inclusion => -180..180
end
