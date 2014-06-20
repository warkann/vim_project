class AddPopularityAndVotedToHacks < ActiveRecord::Migration
  def change
    add_column :hacks, :popularity, :integer, default: 0
    add_column :hacks, :voted, :integer, array: true, default: []
  end
end
