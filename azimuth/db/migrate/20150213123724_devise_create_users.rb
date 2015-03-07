class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name,               null: false, default: ""
      t.string :profile_image_url,	null: false, default: ""
      t.integer :user_id              
    end
    add_index :users, :user_id,                  unique: true
  end
end
