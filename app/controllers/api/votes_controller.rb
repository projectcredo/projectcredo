class Api::VotesController < Api::ApplicationController
  before_action :ensure_current_user
  before_action :set_model

  def create
    @current_user.likes @model
    respond_to do |format|
      format.json { render json: { cached_votes_up: @model.cached_votes_up, voted: true } }
    end
  end

  def destroy
    @current_user.unlike @model
    respond_to do |format|
      format.json { render json: { cached_votes_up: @model.cached_votes_up, voted: false } }
    end
  end

  private
    def set_model
      if params[:type] == 'list'
        @model = List.find(params[:id])
      elsif params[:type] == 'comment'
        @model = Comment.find(params[:id])
      else
        bad_request()
      end
    end
end
