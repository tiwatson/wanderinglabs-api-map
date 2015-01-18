class MapPlaceArrivalDistance < ActiveRecord::Migration
  def change
    add_column :map_places, :arrival_distance, :decimal
  end
end
