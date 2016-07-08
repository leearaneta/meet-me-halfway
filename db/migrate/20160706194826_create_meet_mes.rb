class CreateMeetMes < ActiveRecord::Migration[5.0]
  def change
    create_table :meet_mes do |t|
      t.string :term
      t.integer :results
      t.timestamps
    end
  end
end
