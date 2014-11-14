class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string  :title
      t.integer :user_id
      t.timestamps
    end
  end
end
