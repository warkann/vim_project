class CreateColorschemas < ActiveRecord::Migration
  def change
    create_table :colorschemas do |t|
      t.string :title,		null: false
      t.text :body,			null: false
      t.integer :user_id,	null: false
      t.string :colorschema_img, default: ""
      t.string :slug,		null: false

      t.timestamps
    end
      add_index :colorschemas, :slug, unique: true
      add_index :colorschemas, :title
  end
end
