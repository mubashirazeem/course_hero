class SearchController < ApplicationController
  def index
    @q = Pdf.ransack(params[:q])
    @pdfs = @q.result(distinct: true).includes(:doc_type)
  end
end
