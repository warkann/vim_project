class CreateSpectators < ActiveRecord::Migration
  def change
    create_table :spectators do |t|
    	t.integer :user_id
     	t.string	:s_model
    	t.string	:s_action

      t.timestamps
    end
  end
end
