class CreateIcebergs < ActiveRecord::Migration
  def change
    create_table :icebergs do |t|
      t.integer :berg_number
      t.date :date
      t.float :latitude
      t.float :longitude
      t.string :size
      t.string :shape

      t.timestamps null: false
    end
  end
end
