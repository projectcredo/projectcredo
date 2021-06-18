class Api::ListsController < Api::ApplicationController
  include ActivitiesHelper
  include NotificationsHelper

  before_action :ensure_current_user, except: [:show]
  before_action :set_user, except: [:create]
  before_action :set_list, except: [:create]

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
    return forbidden() if (@list.user_id != current_api_user.id)

    respond_to do |format|
      if @list.update(list_params)
        format.json { render 'jbuilders/_list.json.jbuilder', {locals: {list: @list}} }
      else
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    return forbidden() if (@list.user_id != current_api_user.id)

    @list.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def remove_attachment
    return forbidden() if (@list.user_id != current_api_user.id)

    unless @list.public_send(params[:type]).respond_to?(:destroy)
      render :nothing => true, :status => :bad_request
      return
    end

    @list.public_send(params[:type]).destroy
    @list.save
    render 'jbuilders/_list.json.jbuilder', {locals: {list: @list}}
  end

  private
    def set_user
      params.require(:username)
      @user = User.find_by 'LOWER(username) = ?', params[:username].downcase
      not_found unless @user
    end

    def set_list
      params.require(:slug)
      @list = @user.lists.find_by slug: params[:slug]
      not_found unless @list
    end

    def list_params
      params.permit(:name, :description, :tag_list, :cover)
    end
end
