class CreateOpeningCandidates < ActiveRecord::Migration
  def change
    create_table :opening_candidates do |t|
      t.belongs_to :opening
      t.belongs_to :candidate
    end
    add_index :opening_candidates, :opening_id
    add_index :opening_candidates, :candidate_id
  end
end
