class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :speciality, foreign_key: true
      t.references :grade, foreign_key: true

      t.timestamps
    end

  end
end