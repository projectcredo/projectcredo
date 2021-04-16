class Api::SummariesController < Api::ApplicationController
  before_action :ensure_current_user
  before_action :get_summary, only:[:update, :destroy]

  def create
    param! :list_id, Integer, required: true
    list = List.find(params[:list_id])
    forbidden() if (list.user_id != current_api_user.id)
    summary = list.summaries.build(summary_params)
    summary.user = current_api_user
    summary.evidence_rating = 20
    summary.save

    render json: summary.as_json
  end

  def update
    forbidden() if (@summary.list.user_id != current_api_user.id)
    @summary.update(summary_params)

    render json: @summary.as_json
  end

  def destroy
    forbidden() if (@summary.list.user_id != current_api_user.id)
    @summary.destroy

    head :ok
  end

  private
    def get_summary
      @summary = Summary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def summary_params
      params.require(:summary).permit(:content)
    end
end
