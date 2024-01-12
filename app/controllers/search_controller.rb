class SearchController < ApplicationController
  def index
    @q = Pdf.ransack(params[:q])
    @pdfs = @q.result(distinct: true)
  end
end
