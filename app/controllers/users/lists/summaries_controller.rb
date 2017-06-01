class Users::Lists::SummariesController < ApplicationController
  before_action :ensure_current_user
  before_action :get_list
  before_action :get_summary, only:[:edit, :update]

  def new
    @summary = Summary.new
  end

  def create
    @summary = @list.summaries.build(summary_params)
    @summary.user = current_user

    respond_to do |format|
      if @summary.save
        format.html {redirect_to user_list_path(@list.owner, @list), notice: 'Thank you for creating a summary.'}
      else
        format.html { render 'new'}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @summary.update(summary_params)
        format.html {redirect_to user_list_path(@list.owner, @list), notice: 'Summary was updated.'}
      else
        format.html { redirect_back(fallback_location: root_path, alert: 'Summary failed to update.') }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_list
      @list = List.find_by(slug: params[:user_list_id])
    end

    def get_summary
      @summary = Summary.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def summary_params
      params.require(:summary).permit(:content, :evidence_rating)
    end
end
