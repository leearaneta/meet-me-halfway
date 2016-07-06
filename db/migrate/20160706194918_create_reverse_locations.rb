class CreateReverseLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :reverse_locations do |t|
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
