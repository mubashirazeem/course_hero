# spec/factories/pdfs.rb

FactoryBot.find_definitions unless FactoryBot.factories.registered?(:pdf)

FactoryBot.define do
  factory :pdf do
    title { 'Sample Title' }
    course_name { 'Sample Course' }
    subject { 'Sample Subject' }
    user
    doc_type
    school
    document { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'sample.pdf'), 'application/pdf') }
  end
end
