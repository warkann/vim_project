class AddVotedToPlugins < ActiveRecord::Migration
  def change
  	add_column :plugins, :voted, :integer, array: true, default: []
  end
end
