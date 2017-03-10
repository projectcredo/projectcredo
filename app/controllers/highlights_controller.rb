class HighlightsController < ApplicationController
  before_action :ensure_current_user

  def create
    paper = Paper.find(params[:paper_id])
    paper.highlights.create(highlight_params)

    respond_to do |format|
      format.json { head :created }
    end
  end

  private
    def highlight_params
      params.require(:highlight).permit(:substring)
    end
end
