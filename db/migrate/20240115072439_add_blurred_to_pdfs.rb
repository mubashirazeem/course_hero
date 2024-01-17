class AddBlurredToPdfs < ActiveRecord::Migration[7.1]
  def change
    add_column :pdfs, :blurred, :boolean
  end
end
