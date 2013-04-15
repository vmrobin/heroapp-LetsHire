class RenameOpeningCandidateAssessmentToAssessment < ActiveRecord::Migration
  def up
    rename_table :opening_candidate_assessments, :assessments
  end

  def down
    rename_table :assessments, :opening_candidate_assessments
  end
end
