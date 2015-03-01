class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name,               null: false, default: ""
      t.integer :uid              
      t.timestamps null: false
    end
    add_index :users, :uid,                  unique: true
  end
end
