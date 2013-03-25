class CreateOpeningParticipants < ActiveRecord::Migration
  def change
    create_table :opening_participants, :id => false do |t|
      t.belongs_to :user
      t.belongs_to :opening
    end
    add_index :opening_participants, :user_id
    add_index :opening_participants, :opening_id
  end
end
