class Tweet < ActiveRecord::Base
  belongs_to :user
  validates :tweet_id, :time_stamp, :longitude,  :presence => true 
  validates :tweet_id, uniqueness: true
end
