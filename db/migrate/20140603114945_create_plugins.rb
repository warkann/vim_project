class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
    	t.string :title, 		null: false
    	t.string :description,	null: false
    	t.string :link,			null: false
    	t.integer :user_id,		null: false
    	t.string :slug, 		null: false

      t.timestamps
    end
    	add_index :plugins, :slug, unique: true
    	add_index :plugins, :title
  end
end
