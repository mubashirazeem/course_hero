class CreatePdfs < ActiveRecord::Migration[7.1]
  def change
    create_table :pdfs do |t|
      t.string :title
      t.string :course_name
      t.string :subject
      t.references :user, null: false, foreign_key: true


      t.timestamps
    end
  end
end