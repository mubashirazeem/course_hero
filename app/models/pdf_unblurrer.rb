class PdfUnblurrer < ApplicationRecord
  belongs_to :user
  belongs_to :pdf
end
