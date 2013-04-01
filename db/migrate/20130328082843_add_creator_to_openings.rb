class AddCreatorToOpenings < ActiveRecord::Migration
  def change
    add_column :openings, :creator_id, :integer
    add_index :openings, :creator_id
  end
end
