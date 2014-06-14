class CreateHacks < ActiveRecord::Migration
  def change
    create_table :hacks do |t|
      t.string :title,		null: false
      t.text :body,			null: false
      t.integer :user_id,	null: false
      t.string :slug, 		null: false

      t.timestamps
    end
      add_index :hacks, :slug, unique: true
      add_index :hacks, :title
  end
end
