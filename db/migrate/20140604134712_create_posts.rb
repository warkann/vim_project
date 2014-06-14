class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :title,	null: false
    	t.string :body,		null: false
    	t.integer :user_id,	null: false
		t.string :post_img, default: ""
		t.string :slug, 	null: false

      t.timestamps
    end
		add_index :posts, :slug, unique: true
		add_index :posts, :title
  end
end
