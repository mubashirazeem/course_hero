# spec/models/pdf_spec.rb

require 'rails_helper'
require 'factories/pdfs'

RSpec.describe Pdf, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:doc_type) }
    it { is_expected.to belong_to(:school) }
    it { is_expected.to have_one_attached(:document) }
  end

  describe 'attributes' do
    it { is_expected.to have_db_column(:unlocked).with_default(false) }
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:pdf) { create(:pdf, user: user, unlocked: true) }

    describe '#unlock_pdf?' do
      # Existing tests for unlock_pdf? method
    end
  end

  describe 'callbacks' do
    describe 'after_create :increment_uploads_count' do
      # Existing tests for after_create callback
    end
  end

  describe 'uploading a PDF' do
    let(:user) { create(:user) }

    context 'when a PDF is successfully created' do
      let(:pdf_attributes) { attributes_for(:pdf, user: nil) }

      it 'increments uploads_count for the user' do
        expect { Pdf.create(pdf_attributes.merge(user: user)) }.to change { user.reload.uploads_count }.by(1)
      end

      it 'attaches a document to the PDF' do
        pdf = Pdf.create(pdf_attributes.merge(user: user))
        expect(pdf.document).to be_attached
      end
    end
  end
end
