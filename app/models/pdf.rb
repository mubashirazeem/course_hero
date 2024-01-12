class Pdf < ApplicationRecord
  belongs_to :user
  belongs_to :doc_type

  has_one_attached :document

  belongs_to :school

  attribute :blurred, default: true
  attribute :unlocked, default: false

  after_create :increment_uploads_count
  
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
