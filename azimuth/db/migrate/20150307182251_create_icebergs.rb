class CreateIcebergs < ActiveRecord::Migration
  def change
    create_table :icebergs do |t|
      t.integer :ice_year
      t.integer :berg_number
      t.datetime :time
      t.float :latitude
      t.float :longitude
      t.string :method
      t.string :size
      t.string :shape
      t.string :source

      t.timestamps null: false
    end
  end
end
