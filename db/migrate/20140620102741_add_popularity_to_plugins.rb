class AddPopularityToPlugins < ActiveRecord::Migration
  def change
    add_column :plugins, :popularity, :integer, default: 0
  end
end
