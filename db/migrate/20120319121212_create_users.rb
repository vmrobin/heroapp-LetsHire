class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :email, :null => false    # email is used as the unique identifier of user
      t.string  :password, :null => false # encrypted password
      t.string  :name                     # display name
      t.boolean :admin, :null => false, :default => false # whether is system administrator
      t.timestamps
    end

    add_index :users, [:email], :unique => true, :name => 'users_email_index'
  end
end
