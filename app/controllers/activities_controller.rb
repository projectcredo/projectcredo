class ActivitiesController < ApplicationController

  def index
    @visible_lists = List.by_activity.first(30)
    @include_activities = true

    respond_to do |format|
      format.html
      format.json {render 'jbuilders/_lists.json.jbuilder', {locals: {lists: @visible_lists}}}
    end
  end

end
