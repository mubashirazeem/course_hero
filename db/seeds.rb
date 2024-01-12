# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


DocType.create(name: "Assignment")
DocType.create(name: "Assessment")
DocType.create(name: "Lab Report")
DocType.create(name: "Notes")
DocType.create(name: "Essay")
DocType.create(name: "Test Prep")
DocType.create(name: "Lecture Slides")
DocType.create(name: "Homework Help")



School.create(name: "University of Management & Technology")
School.create(name: "University of Central Punjab")
