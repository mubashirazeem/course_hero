class PdfsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pdfs = current_user.pdfs
    # @blurred_pdfs = Pdf.where.not(user: current_user).update_all(blurred: true)
  end

  # def show
  #   @pdf = Pdf.find(params[:id])
    
  #   @pdf.update(unlocked: true) if current_user == @pdf.user
  # end
  def show
    @pdf = Pdf.find(params[:id])
    @pdf.update(unlocked: true) if current_user == @pdf.user && !@pdf.unlocked
  end
  
  
  def new
    @pdf = Pdf.new
  end

  def create    
    if current_user
      @pdf = current_user.pdfs.build(pdf_params)
      @pdf.title = extract_title_from_document
      @pdf.school_id = current_user.school_id

      if @pdf.save
        redirect_to @pdf, notice: 'PDF was successfully uploaded.'
      else
        render :new
      end
    else
      redirect_to root_path, alert: 'You need to be signed in to upload PDFs.'
    end
  end

  def unblur
    @pdf = Pdf.find(params[:id])
  
    if current_user.unlocks_count.positive?
      current_user.decrement!(:unlocks_count)
      @pdf.update(unlocked: true)
      redirect_to pdf_path(@pdf), notice: 'PDF unlocked successfully.'
    else
      redirect_to pdfs_path, alert: 'Insufficient unlocks remaining.'
    end
  end

  def unlock_pdf
    @pdf = Pdf.find(params[:id])
  
    if current_user.unlocks_count.positive?
      current_user.decrement!(:unlocks_count)
      @pdf.update(unlocked: true)
      render json: { success: true, unlocks_count: current_user.unlocks_count }
    else
      render json: { success: false, message: 'Insufficient unlocks remaining.' }
    end
  end

  # def unlock_pdf
  #   @pdf = Pdf.find(params[:id])

  #   if current_user.unlocks_count.positive?
  #     current_user.decrement!(:unlocks_count)
  #     @pdf.update(unlocked: true)
  #     puts "PDF Unlocked: #{@pdf.unlocked?}"  # Debugging statement
  #     render 'show', notice: 'PDF unlocked successfully.'
  #     # redirect_to pdfs_path, notice: 'PDF unlocked successfully.'
  #   else
  #     redirect_to pdfs_path, alert: 'Insufficient unlocks remaining.'
  #   end
  # end



  # def unlock_pdf_ajax
  #   @pdf = Pdf.find(params[:id])
  
  #   if current_user.unlocks_count.positive?
  #     current_user.decrement!(:unlocks_count)
  #     @pdf.update(unlocked: true)
  #     render json: { success: true, unlocks_count: current_user.unlocks_count }
  #   else
  #     render json: { success: false, message: 'Insufficient unlocks remaining.' }
  #   end
  # end

  def unlock_pdf_ajax
    @pdf = Pdf.find(params[:id])
    if current_user.unlocks_count.positive?
      current_user.decrement!(:unlocks_count)
      @pdf.update(unlocked: true) unless @pdf.unlocked
      render json: { success: true, unlocks_count: current_user.unlocks_count }
    else
      render json: { success: false, message: 'Insufficient unlocks remaining.' }
    end
  end
  
  
  private

  def extract_title_from_document
    params[:pdf][:document].original_filename if params[:pdf][:document]
  end

  def pdf_params
    params.require(:pdf).permit(:title, :document, :course_name, :subject, :doc_type_id, :user_id)
  end
end
