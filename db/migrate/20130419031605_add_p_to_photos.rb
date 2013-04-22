class AddPToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :p, :oid, :null => false
  end
end
