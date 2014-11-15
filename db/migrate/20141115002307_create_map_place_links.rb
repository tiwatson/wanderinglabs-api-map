class CreateMapPlaceLinks < ActiveRecord::Migration
  def change
    create_table :map_place_links do |t|
      t.integer :map_place_id
      t.string :url
      t.url :title

      t.timestamps
    end
  end
end
