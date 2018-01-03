class CreateMeasurements < ActiveRecord::Migration[5.1]
  def change
    create_table :measurements do |t|
      t.integer :temperature

      t.timestamps
    end
  end
end
