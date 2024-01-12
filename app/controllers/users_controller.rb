class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @pdfs = current_user.pdfs
  end

  def new
    @pdf = current_user.pdfs.new
  end


  private

  def pdf_params
    params.require(:pdf).permit(:title, :document, :course_name, :subject, :doc_type_id, :user_id)
  end

end
