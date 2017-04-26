class Lists::VotesController < ApplicationController
  before_action :ensure_current_user

  def create
    list = List.find(votable_params[:id])
    current_user.likes list
    respond_to do |format|
      format.html { redirect_to :back }
      format.json
    end
  end

  def destroy
    list = List.find(votable_params[:id])
    current_user.unlike list
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
