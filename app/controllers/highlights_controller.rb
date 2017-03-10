class HighlightsController < ApplicationController
  before_action :ensure_current_user

  def create
    paper = Paper.find(params[:paper_id])
    highlight = paper.highlights.new(highlight_params)

    respond_to do |format|
      if highlight.save
        format.json { head :created }
      else
        format.json { render json: highlight.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def highlight_params
      params.require(:highlight).permit(:substring)
    end
end
