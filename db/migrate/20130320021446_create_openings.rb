class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.string :title
      t.string :country
      t.string :province

      t.references :department
      t.integer :hiring_manager_id
      t.integer :recruiter_id
      t.string :description
      t.integer :status, :default => 0

      t.timestamps
    end
    add_index :openings, :hiring_manager_id
    add_index :openings, :recruiter_id
  end
end
