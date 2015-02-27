class AddLatitudeToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :latitude, :float
  end
end
