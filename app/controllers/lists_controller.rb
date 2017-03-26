class ListsController < ApplicationController
  before_action :ensure_current_user, except: [:index]

  # GET /lists
  # GET /lists.json
  def index
    if current_user
      lists = current_user.visible_lists
      @pinned_lists = current_user.visible_lists.merge(current_user.homepage.lists.distinct)
      @unpinned_lists = current_user.visible_lists.where.not(id: @pinned_lists.pluck(:id))
    else
      lists = @unpinned_lists = List.publicly_visible
    end
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  def show
    @list = List.find_by!(slug: params[:id])
  end

  # POST /lists
  # POST /lists.json
  def create
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

        format.html { redirect_to user_list_path(@list.owner, @list), notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description, :tag_list, :access,
                                    list_members: [ :username, :role ])
    end
end
