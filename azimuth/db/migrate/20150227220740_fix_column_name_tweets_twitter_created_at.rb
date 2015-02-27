class FixColumnNameTweetsTwitterCreatedAt < ActiveRecord::Migration
  def change
  	rename_column :tweets, :twitter_created_at, :time_stamp
  end
end
