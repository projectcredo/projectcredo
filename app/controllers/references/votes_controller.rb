class References::VotesController < ApplicationController
  before_action :ensure_current_user

  def create
    reference = Reference.find(votable_params[:id])
    current_user.likes reference
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You like it!' }
      format.js { render 'references/vote.js.erb', locals: {reference: reference} }
    end
  end

  def destroy
    reference = Reference.find(votable_params[:id])
    current_user.unlike reference
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You unlike it!' }
      format.js { render 'references/vote.js.erb', locals: {reference: reference} }
    end
  end

  private
    def votable_params
      params.permit(:id)
    end
end
