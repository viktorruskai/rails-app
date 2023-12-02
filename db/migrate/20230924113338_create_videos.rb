class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :title, null: true
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :videos, [:user_id, :created_at]
  end
end
