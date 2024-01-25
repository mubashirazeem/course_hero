class PdfsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_pdf, only: [:show, :destroy, :unblur, :unlock_pdf]

  def index
    @pdfs = current_user.pdfs.includes(:doc_type)
    # authorize! :index, Pdf
  end

  def show
    @is_unblurred_for_user = PdfUnblurrer.exists?(user: current_user, pdf: @pdf)
    @pdf.update(unlocked: true) if @is_unblurred_for_user && !@pdf.unlocked
    @pdf.update(unlocked: true) if current_user == @pdf.user && !@pdf.unlocked

    ahoy.track "Viewed PDF", pdf_id: @pdf.id
  end

  def new
    @pdf = Pdf.new
    # authorize! :create, @pdf
  end

  def create
    @pdf = current_user.pdfs.build(pdf_params)
    @pdf.title = extract_title_from_document
    @pdf.school_id = current_user.school_id

    # authorize! :create, @pdf

    if @pdf.save
      redirect_to @pdf, notice: 'PDF was successfully uploaded.'
    else
      render :new
    end
  end

  def unblur
    # authorize! :unblur, @pdf
    if current_user.unlocks_count.positive?
      current_user.decrement!(:unlocks_count)
      @pdf.update(unlocked: true)
      store_unblurred_pdf(@pdf)
      redirect_to pdf_path(@pdf), notice: 'PDF unlocked successfully.'
    else
      redirect_to pdfs_path, alert: 'Insufficient unlocks remaining.'
    end
  end

  def unlock_pdf
    # authorize! :unlock_pdf, @pdf
    if current_user.unlocks_count.positive?
      current_user.decrement!(:unlocks_count)
      @pdf.update(unlocked: true)
      store_unblurred_pdf(@pdf)
      render json: { success: true, unlocks_count: current_user.unlocks_count }
    else
      render json: { success: false, message: 'Insufficient unlocks remaining.' }
    end
  end

  def destroy
    # authorize! :destroy, @pdf
    @pdf.destroy
    redirect_to root_path, notice: 'PDF was successfully deleted.'
  end

  private

  def extract_title_from_document
    params[:pdf][:document].original_filename if params[:pdf][:document]
  end

  def pdf_params
    params.require(:pdf).permit(:title, :document, :course_name, :subject, :doc_type_id, :user_id)
  end

  def store_unblurred_pdf(pdf)
    current_user.unblurred_pdfs << pdf
  end

  def load_pdf
    @pdf = Pdf.friendly.find(params[:id])
    render_404 unless @pdf
  end

  def render_404
    render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end
end
