class CreateCarrier < ActiveRecord::Migration[5.0]
  def change
    create_table :carriers do |t|
      t.integer :quantity
    end
  end
end
