class Users::ListsController < ApplicationController
  include ActivitiesHelper
  include NotificationsHelper

  before_action :ensure_current_user, except: [:index, :show]
  before_action :set_user
  before_action :set_list, except: [:index, :remove_attachment]

  def index
    @visible_lists = @user.lists.ranked
  end

  def show
    impressionist(@list, '', :unique => [:session_hash])
    @list.refresh_papers_info
    @references = @list.references.joins(:paper).order(params_sort_order)
    @summaries = @list.summaries.ranked

    respond_to do |format|
      format.html
      format.json {render 'jbuilders/_list.json.jbuilder', {locals: {list: @list}}}
    end
  end

  def edit
    authorize @list
  end

  def update
    param! :list, Object, required: true
    authorize @list

    respond_to do |format|
      if @list.update(list_params)
        format.html {
          redirect_back(fallback_location: user_list_path(@list.user, @list), notice: 'Board was successfully updated.')
        }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @list

    @list.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_attachment
    @list = @user.owned_lists.find_by slug: params[:user_list_id]
    return redirect_back(fallback_location: root_path, alert: 'Board not found.') unless @list

    authorize @list, :update?

    unless @list.respond_to?(params[:type]) and @list.public_send(params[:type]).respond_to?(:destroy)
      redirect_to request.referer || root_path, alert: 'Invalid attachment type'
      return
    end

    @list.public_send(params[:type]).destroy
    @list.save
    redirect_back notice: 'Attachment was deleted', fallback_location: root_path
  end

  private
    def set_user
      @user = User.find_by 'LOWER(username) = ?', params[:username].downcase
      not_found unless @user
    end

    def set_list
      @list = @user.lists.find_by slug: params[:id]
      return redirect_back(fallback_location: root_path, alert: 'Board not found.') unless @list
    end

    def params_sort_order
      if params[:sort] == 'pub_date'
        'papers.published_at DESC NULLS LAST'
      else # default to ordering by votes first, then create date
        "cached_votes_up DESC, created_at ASC"
      end
    end

    def list_params
      params.require(:list).permit(:name, :description, :tag_list, :cover)
    end
end
