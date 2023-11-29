class CreateVideoNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :video_notes do |t|
      t.references :video, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :note

      t.timestamps
    end
    add_index :video_notes, [:note, :created_at]
  end
end
