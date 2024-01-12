class AddSchoolReferencesToUsersAndPdfs < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :school, foreign_key: true
    add_reference :pdfs, :school, foreign_key: true
  end
end
