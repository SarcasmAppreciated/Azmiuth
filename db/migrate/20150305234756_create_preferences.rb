class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
    	t.references :user, index: true
    	t.float :destination_latitude
    	t.float :destination_longitude
    end
    add_foreign_key :preferences, :users
  end
end
