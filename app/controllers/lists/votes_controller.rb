class Lists::VotesController < ApplicationController
  before_action :ensure_current_user
  before_action :set_list

  def create
    current_user.likes @list
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You like it!' }
      format.js { render nothing: true, status: 204 }
    end
  end

  def destroy
    current_user.unlike @list
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You unlike it!' }
      format.js { render nothing: true, status: 204 }
    end
  end

  private
    def votable_params
      params.permit(:list_id)
    end

    def set_list
      @list = List.find_by!(slug: votable_params[:list_id])
    end
end
