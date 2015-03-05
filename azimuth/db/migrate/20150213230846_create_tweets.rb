class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :user, index: true
      t.string :tweet_text
      t.datetime :time_stamp
      t.float    :latitude
      t.float    :longitude
      t.integer :tweet_id, :limit => 8,  :unique => true
    end
    add_foreign_key :tweets, :users
  end
end
