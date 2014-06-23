class AddPopularityToHacks < ActiveRecord::Migration
  def change
    add_column :hacks, :popularity, :integer, default: 0
  end
end
