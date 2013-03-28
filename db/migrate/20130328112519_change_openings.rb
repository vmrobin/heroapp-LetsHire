class ChangeOpenings < ActiveRecord::Migration
  def up
    change_column :openings, :description, :text
  end

  def down
    change_column :openings, :description, :string
  end
end
