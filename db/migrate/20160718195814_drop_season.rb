class DropSeason < ActiveRecord::Migration[5.0]
  def change
    drop_table :seasons
  end
end
