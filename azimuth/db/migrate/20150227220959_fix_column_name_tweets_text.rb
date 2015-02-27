class FixColumnNameTweetsText < ActiveRecord::Migration
  def change
  	 rename_column :tweets, :text, :tweet_text
  end
end
