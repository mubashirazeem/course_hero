class Pdf < ApplicationRecord
  extend FriendlyId

  belongs_to :user
  belongs_to :doc_type

  has_one_attached :document
  
  has_many :pdf_unblurrers, dependent: :destroy
  has_many :unblurred_by_users, through: :pdf_unblurrers, source: :user

  belongs_to :school

  attribute :unlocked, default: false

  after_create :increment_uploads_count

  friendly_id :title, use: %i[slugged]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

  def unlock_pdf?
    unlocked? && user.unlocks_count.positive?
  end

  private

  def increment_uploads_count
    user.increment!(:uploads_count) if user.student?
    user.send(:grant_unlocks) # Use send to call protected method
  end

  def self.ransackable_attributes(auth_object = nil)
    ["course_name", "created_at", "doc_type_id", "id", "id_value", "school_id", "subject", "title", "updated_at", "user_id"]
  end
end
