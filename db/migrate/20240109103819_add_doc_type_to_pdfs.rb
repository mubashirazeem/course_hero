class AddDocTypeToPdfs < ActiveRecord::Migration[7.1]
  def change
    add_reference :pdfs, :doc_type, null: false, foreign_key: true
  end
end
