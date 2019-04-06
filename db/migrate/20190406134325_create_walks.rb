class CreateWalks < ActiveRecord::Migration[5.2]
  def change
    create_table :walks do |t|
      t.string :start_location, null: false
      t.string :end_location, null: false
      t.float :distance, null: false

      t.timestamps
    end
  end
end
