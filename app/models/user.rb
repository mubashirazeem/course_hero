class User < ApplicationRecord
  after_create :initialize_counts
  after_commit :grant_unlocks, on: :create
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  enum role: { student: 'student', educator: 'educator' }
  
  has_many :pdfs, dependent: :destroy

  has_many :pdf_unblurrers, dependent: :destroy
  has_many :unblurred_pdfs, through: :pdf_unblurrers, source: :pdf

  belongs_to :school

  validates :school_id, presence: true

  attribute :uploads_count, default: 0
  attribute :unlocks_count, default: 0

  has_many :visits, class_name: "Ahoy::Visit"

  private

  def initialize_counts
    update(uploads_count: 0, unlocks_count: 0)
  end

  protected
  
  def grant_unlocks
    if uploads_count % 3 == 0 && uploads_count != 0
      increment!(:unlocks_count, 5)
    end
  end
end
