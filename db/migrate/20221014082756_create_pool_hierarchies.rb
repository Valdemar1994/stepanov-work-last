class CreatePoolHierarchies < ActiveRecord::Migration[7.0]
  def change
    create_table :pool_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :pool_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "pool_anc_desc_idx"

    add_index :pool_hierarchies, [:descendant_id],
      name: "pool_desc_idx"
  end
end
