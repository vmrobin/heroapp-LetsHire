class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.string :title
      t.string :country
      t.string :state

      t.references :department
      t.integer :hiring_manager_id
      t.integer :recruiter_id
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
