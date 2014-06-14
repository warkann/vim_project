class CreateDotfiles < ActiveRecord::Migration
  def change
    create_table :dotfiles do |t|
      t.string :title,		null: false
      t.text :body,			null: false
      t.integer :user_id,	null: false
      t.string :slug,		null: false

      t.timestamps
    end
      add_index :dotfiles, :slug, unique: true
      add_index :dotfiles, :title
  end
end
