class CreateFeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :feeds do |t|
      t.belongs_to :episode, foreign_key: true

      t.timestamps
    end
  end
end
