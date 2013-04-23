class AddColumnsToOpeningAndAddAssessment < ActiveRecord::Migration
  def change
    add_column :openings, :total_no, :integer, :default => 1
    add_column :openings, :filled_no, :integer, :default => 0

    create_table :opening_candidate_assessments do |t|
      t.belongs_to :opening_candidate
      t.integer :creator_id
      t.text :comment

      t.timestamps
    end

    add_column :opening_candidates, :status, :integer, :default => 1
  end
end
