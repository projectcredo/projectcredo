class PapersController < ApplicationController
  before_action :set_paper, except: :search
  before_action :ensure_current_user, except: :show

  # GET /papers/1
  # GET /papers/1.json
  def show
  end

  # GET /papers/1/edit
  def edit
  end

  # PATCH/PUT /papers/1
  # PATCH/PUT /papers/1.json
  def update
    respond_to do |format|
      if @paper.update(paper_params)
        format.html { redirect_back(fallback_location: root_path, notice: 'Paper was successfully updated.') }
        format.json
      else
        format.html { redirect_back(fallback_location: root_path, alert: 'Paper failed to update') }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    unless params.has_key?(:query) and params[:query].present? then raise ActionController::BadRequest.new(), 'Param "query" is required' end

    excludeIds = []
    if (params[:hide_added].present? and params[:hide_added].present?) 
      excludeIds = params[:hide_added] == '1' ? List.find(params[:list_id]).papers.pluck(:id) : []
    end

    render :json => PaperSearchService.new.search(params[:query], excludeIds)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paper_params
      params.require(:paper).permit(
        :title, :abstract, :doi, :pubmed_id, :published_at, :publication,
        tag_list: [],
        bias_list: [],
        methodology_list: [],
        links_attributes: [:id, :url],
        authors_attributes: [:id, :given_name, :family_name])
    end
end
