class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :value
      t.string :type
      t.string :timestamp
      t.string :driver_id
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
