class References::VotesController < ApplicationController
  before_action :ensure_current_user
  before_action :set_reference

  def create
    current_user.likes @reference
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You like it!' }
      format.json { render nothing: true, status: 204 }
    end
  end

  def destroy
    current_user.unlike @reference
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You unlike it!' }
      format.json { render nothing: true, status: 204 }
    end
  end

  private
    def votable_params
      params.permit(:reference_id)
    end

    def set_reference
      @reference = Reference.find(votable_params[:reference_id])
    end
end
