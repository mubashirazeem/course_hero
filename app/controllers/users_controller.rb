class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @pdfs = current_user.pdfs.includes(:doc_type)
    # authorize! :index, :pdf
    # @pdfs = current_user.unblurred_pdfs
  end

  def new
    @pdf = current_user.pdfs.new
    authorize! :new, :pdf
  end


  private

  def pdf_params
    params.require(:pdf).permit(:title, :document, :course_name, :subject, :doc_type_id, :user_id)
  end

end
