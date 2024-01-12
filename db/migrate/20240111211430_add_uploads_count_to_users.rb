class AddUploadsCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :uploads_count, :integer
  end
end
