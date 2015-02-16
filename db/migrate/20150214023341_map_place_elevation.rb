class MapPlaceElevation < ActiveRecord::Migration
  def change
    add_column :map_places, :elevation, :integer
  end
end
