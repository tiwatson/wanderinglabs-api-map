class CreateMapPlaces < ActiveRecord::Migration
  def change
    create_table :map_places do |t|
      t.integer  :map_id
      t.string   "title"
      t.float    "latitude"
      t.float    "longitude"
      t.date     "arrived"
      t.text     "description"
      t.integer  "price"
      t.string   "category"
      t.string   "city"
      t.string   "state"
      t.string   "country"
      t.text     "arrival_path",         default: [], array: true
      t.string   "establishment"
      t.integer  "stay_length",          default: 0
      t.integer  "price_total"
      t.integer  "price_adjusted"
      t.integer  "price_adjusted_total"
      t.timestamps
    end
  end
end
