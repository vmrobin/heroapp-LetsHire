class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.string :type,           :null => false
      t.string :title,          :null => false
      t.text :description
      t.string :status
      t.float :score
      t.text :assessment
      t.datetime :scheduled_at, :null => false
      t.integer :duration
      t.string :phone
      t.string :location

      t.timestamps
    end
  end
end
