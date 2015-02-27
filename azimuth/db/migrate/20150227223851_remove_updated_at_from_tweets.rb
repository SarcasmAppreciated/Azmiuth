class RemoveUpdatedAtFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :updated_at, :datetime
  end
end
