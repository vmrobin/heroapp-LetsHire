class ChangeToUniqIndex < ActiveRecord::Migration
  def up
    remove_index :interviewers, :interview_id
    remove_index :interviewers, :user_id
    add_index :interviewers, [:user_id, :interview_id], :unique => true

    remove_index :opening_participants, :user_id
    remove_index :opening_participants, :opening_id
    add_index :opening_participants, [:user_id, :opening_id], :unique => true

    remove_index :opening_candidates, :opening_id
    remove_index :opening_candidates, :candidate_id
    add_index :opening_candidates, [:opening_id, :candidate_id], :unique => true

  end

  def down
    remove_index :interviewers, [:user_id, :interview_id]
    add_index :interviewers, :interview_id
    add_index :interviewers, :user_id

    remove_index :opening_participants, [:user_id, :opening_id]
    add_index :opening_participants, :user_id
    add_index :opening_participants, :opening_id

    remove_index :opening_candidates, [:opening_id, :candidate_id]
    add_index :opening_candidates, :opening_id
    add_index :opening_candidates, :candidate_id

  end
end
