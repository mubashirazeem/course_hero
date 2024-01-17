# spec/models/pdf_spec.rb
require 'rails_helper'

RSpec.describe Pdf, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:doc_type) }
    it { should belong_to(:school) }
    it { should have_one_attached(:document) }
  end

  describe 'attributes' do
    it { should have_attribute(:unlocked).with_default_value_of(false) }
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:pdf) { create(:pdf, user: user, unlocked: true) }

    describe '#unlock_pdf?' do
      context 'when the PDF is unlocked and the user has positive unlocks_count' do
        it 'returns true' do
          expect(pdf.unlock_pdf?).to be true
        end
      end

      context 'when the PDF is not unlocked' do
        before { pdf.update(unlocked: false) }

        it 'returns false' do
          expect(pdf.unlock_pdf?).to be false
        end
      end

      context 'when the user has zero unlocks_count' do
        before { user.update(unlocks_count: 0) }

        it 'returns false' do
          expect(pdf.unlock_pdf?).to be false
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'after_create :increment_uploads_count' do
      let(:user) { create(:user, role: :student) }
      let(:pdf) { build(:pdf, user: user) }

      it 'increments uploads_count for student user' do
        expect { pdf.save }.to change { user.reload.uploads_count }.by(1)
      end

      it 'calls grant_unlocks method for student user' do
        allow(user).to receive(:grant_unlocks)
        pdf.save
        expect(user).to have_received(:grant_unlocks)
      end

      it 'does not increment uploads_count for non-student user' do
        user.update(role: :teacher)
        expect { pdf.save }.not_to change { user.reload.uploads_count }
      end

      it 'does not call grant_unlocks method for non-student user' do
        user.update(role: :teacher)
        allow(user).to receive(:grant_unlocks)
        pdf.save
        expect(user).not_to have_received(:grant_unlocks)
      end
    end
  end

  describe 'class methods' do
    describe '.ransackable_attributes' do
      it 'returns an array of ransackable attributes' do
        expect(described_class.ransackable_attributes).to eq(
          ["course_name", "created_at", "doc_type_id", "id", "id_value", "school_id", "subject", "title", "updated_at", "user_id"]
        )
      end
    end
  end
end
