class AddCityToOpening < ActiveRecord::Migration
  def change
    add_column :openings, :city, :string
  end
end
