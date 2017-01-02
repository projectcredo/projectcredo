class ListsController < ApplicationController
  before_action :ensure_current_user, except: [:index]

  # GET /lists
  # GET /lists.json
  def index
    if current_user
      @pinned_lists = current_user.visible_lists.merge(current_user.homepage.lists.distinct)
      @unpinned_lists = current_user.visible_lists.where.not(id: @pinned_lists.pluck(:id))
    else
      @unpinned_lists = List.publicly_visible
    end
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = current_user.lists.build(list_params)
    member = User.find_by username: params[:list].delete(:members)
    @list.list_memberships.build(user: member, role: :contributor) if member

    respond_to do |format|
      if @list.save
        current_user.homepage.lists << @list
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
      params.require(:list).permit(:name, :description, :tag_list, :participants)
    end
end
