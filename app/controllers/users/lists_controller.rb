class Users::ListsController < ApplicationController
  include ActivitiesHelper
  include NotificationsHelper

  before_action :ensure_current_user, except: [:index, :show]
  before_action :set_user
  before_action :set_list, except: :index
  before_action :ensure_editable, only: [:edit, :update]
  before_action :ensure_visible, only: :show

  def index
    if current_user
      @visible_lists = @user.lists.visible_to(current_user).ranked
    else
      @visible_lists = @user.lists.publicly_visible.ranked
    end
  end

  def show
    impressionist(@list, '', :unique => [:session_hash])
    @list.refresh_papers_info
    @references = @list.references.joins(:paper).order(params_sort_order)
    @summaries = @list.summaries.ranked
  end

  def edit
    @members = User.where.not(id: @list.list_memberships.pluck(:user_id)).map do |m|
      { username: m.username, role: 'nonmember' }
    end
  end

  def update
    members = params[:list].delete(:list_members) || []

    if current_user.can_edit?(@list)

      remove_current_user = @list.members.include?(current_user) && !members.include?(current_user.username) && current_user != @list.owner

      memberships = members.map do |member|
        @list.list_memberships.find_or_create_by(
          user: User.find_by(username: member),
          role: :contributor
        )
      end
      memberships << @list.list_memberships.find_by(user: @list.owner, role: :owner)
      @list.list_memberships = memberships
    end

    params[:list].delete(:access) unless current_user == @list.owner

    respond_to do |format|
      if @list.update(list_params)
        format.html {
          if remove_current_user
            redirect_to user_list_path(@list.user, @list), notice: 'Board was successfully updated and you have removed yourself as a contributor'
          else
            redirect_back(fallback_location: user_list_path(@list.user, @list), notice: 'Board was successfully updated.')
          end
        }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_user == @list.owner
      return redirect_back(fallback_location: root_path, alert: 'Only the board owner can delete a board.')
    end

    @list.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find_by 'LOWER(username) = ?', params[:username].downcase
    end

    def set_list
      @list = @user.owned_lists.find_by slug: params[:id]
      return redirect_back(fallback_location: root_path, alert: "Board not found.") unless @list
    end

    def params_sort_order
      if params[:sort] == 'pub_date'
        'papers.published_at DESC NULLS LAST'
      else # default to ordering by votes first, then create date
        "cached_votes_up DESC, created_at ASC"
      end
    end

    def list_params
      params.require(:list).permit(:name, :description, :tag_list, :access,
                                      list_members: [ :username, :role ])
    end

    def ensure_editable
      redirect_to(root_path) unless current_user

      unless current_user.can_edit? @list
        return redirect_back(
          fallback_location: root_path,
          alert: 'You must be a contributor to make changes to this board.'
        )
      end
    end

    def ensure_visible
      return if @list.visible_to_public?
      return redirect_back(fallback_location: root_path) unless current_user && current_user.can_view?(@list)
    end
end
