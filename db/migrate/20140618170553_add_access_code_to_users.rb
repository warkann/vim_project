class AddAccessCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_code, :integer, default: 100
  end
end
