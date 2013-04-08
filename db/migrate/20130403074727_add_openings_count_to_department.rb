class AddOpeningsCountToDepartment < ActiveRecord::Migration
  def change
    add_column :departments, :openings_count, :integer
  end
end
