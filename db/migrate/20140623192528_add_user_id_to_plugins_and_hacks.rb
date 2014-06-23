class AddUserIdToPluginsAndHacks < ActiveRecord::Migration
  def change
  	add_column :users, :plugin_id, :integer, array: true, default: []
  	add_column :users, :hack_id, :integer, array: true, default: []
  end
end
