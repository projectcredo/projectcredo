class Api::ListsController < Api::ApplicationController
  include ActivitiesHelper
  include NotificationsHelper

  before_action :authenticate_api_user!, except: [:show]
  before_action :set_user, except: [:create]
  before_action :set_list, except: [:create, :remove_attachment]

  def show
    impressionist(@list, '', :unique => [:session_hash])
    @list.refresh_papers_info

    render 'jbuilders/_list.json.jbuilder', {locals: {list: @list}}
  end

  def create
    members = params.delete(:list_members) || []
    @list = current_api_user.lists.build(list_params)

    respond_to do |format|
      if @list.save
        current_api_user.homepage.lists << @list

        create_activity_and_notifications(
          actable: @list,
          activity_type: "created",
          users: [@list.user]
        )

        format.json { render 'jbuilders/_list.json.jbuilder', {locals: {list: @list}} }
      else
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    param! :list, Object, required: true
    authorize @list

    respond_to do |format|
      if @list.update(list_params)
        format.json { render :show, status: :ok, location: @list }
      else
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @list

    @list.destroy

    respond_to do |format|
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
      @list = @user.lists.find_by slug: params[:slug]
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
      params.permit(:name, :description, :tag_list, :cover)
    end
end
