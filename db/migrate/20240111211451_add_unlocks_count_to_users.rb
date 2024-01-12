class AddUnlocksCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :unlocks_count, :integer
  end
end
