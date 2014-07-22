class RemoveIndexToUsers < ActiveRecord::Migration
  def change
  	remove_index(:users, :email)
  	remove_index(:users, :slug)
  	remove_index(:users, :nickname)
  end
end
