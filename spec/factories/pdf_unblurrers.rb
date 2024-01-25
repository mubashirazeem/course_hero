# spec/factories/pdf_unblurrers.rb

unless FactoryBot.factories.registered?(:pdf_unblurrer)
  FactoryBot.find_definitions
end

FactoryBot.define do
  factory :pdf_unblurrer do
    user { nil }
    pdf { nil }
  end
end
