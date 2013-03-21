class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, :null => false
      t.integer :permission_id, :null => false
      t.timestamps
    end
  end
end
