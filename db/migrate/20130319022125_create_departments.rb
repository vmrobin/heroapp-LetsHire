class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :description
    end

    add_index :departments, :name, unique: true
  end
end
