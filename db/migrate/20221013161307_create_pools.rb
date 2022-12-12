class CreatePools < ActiveRecord::Migration[7.0]
  def change
    create_table :pools do |t|
      t.string :type, null: false
      t.references :profile, index: {unique: true}, foreign_key: {on_delete: :cascade}
            
      t.timestamps
    end

    add_index :pools, :type

  end
end
