class CreatePoolContainers < ActiveRecord::Migration[7.0]
  def change
    create_table :pool_containers do |t|
      t.references :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
    
    add_reference :pools, :pool_container, foreign_key: { on_delete: :cascade }
  end
end
