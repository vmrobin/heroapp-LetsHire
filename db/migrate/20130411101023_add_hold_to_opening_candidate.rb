class AddHoldToOpeningCandidate < ActiveRecord::Migration
  def change
    add_column :opening_candidates, :hold, :boolean
  end
end
