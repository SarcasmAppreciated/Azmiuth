class RemoveCreatedAtFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :created_at, :datetime
  end
end
