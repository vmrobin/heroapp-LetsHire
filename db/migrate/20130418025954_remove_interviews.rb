class RemoveInterviews < ActiveRecord::Migration
  def up
    # We change literal values for Interview.status
    # So dump existing records
    Interviewer.destroy_all
    Interview.destroy_all
  end

  def down
  end
end
