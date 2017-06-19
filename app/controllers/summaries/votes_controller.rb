class Summaries::VotesController < ApplicationController
  before_action :ensure_current_user

  def create
    summary = Summary.find(votable_params[:id])
    current_user.likes summary
    respond_to do |format|
      format.html { redirect_to :back }
      format.json
    end
  end

  def destroy
    summary = Summary.find(votable_params[:id])
    current_user.unlike summary
    respond_to do |format|
      format.html { redirect_to :back }
      format.json
    end
  end

  private
    def votable_params
      params.permit(:id)
    end
end
