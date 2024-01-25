class CreatePdfUnblurrers < ActiveRecord::Migration[7.1]
  def change
    create_table :pdf_unblurrers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pdf, null: false, foreign_key: true

      t.timestamps
    end
  end
end
