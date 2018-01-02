class ListsController < ApplicationController
  include ActivitiesHelper
  include NotificationsHelper

  before_action :ensure_current_user, except: [:index]
  before_action :set_list, except: :index

  # GET /lists
  # GET /lists.json
  def index
    if current_user
      @visible_lists = current_user.visible_lists.ranked
    else
      @visible_lists = List.publicly_visible.ranked
    end
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # POST /lists
  # POST /lists.json
  def create
    puts params.inspect
    members = params[:list].delete(:list_members)
    @list = current_user.lists.build(list_params)

    respond_to do |format|
      if @list.save
        current_user.homepage.lists << @list
        if members
          members.map do |m|
            @list.list_memberships.create(
              user: User.find_by(username: m),
              role: :contributor
            )
          end
        end

        create_activity_and_notifications(
          actable: @list,
          activity_type: "created",
          users: @list.members
        )

        format.html { redirect_to user_list_path(@list.owner, @list), notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def form_contributors
    exclude = if @list then @list.owner.id else current_user.id end

    users = User.where.not(id: exclude)
      .where('username LIKE ?', "#{params[:query]}%").limit(12).map do |m|
      { id: m.id, username: m.username, avatar: m.avatar(:thumb) }
    end

    render :json => users
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = current_user.owned_lists.find_by slug: params[:list_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description, :tag_list, :access,
                                    list_members: [ :username, :role ])
    end
end
