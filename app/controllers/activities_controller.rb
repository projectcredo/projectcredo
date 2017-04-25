class ActivitiesController < ApplicationController

  def index
    if current_user
      @visible_lists = current_user.visible_lists.by_activity.last(50)
    else
      @visible_lists = List.publicly_visible.by_activity.last(50)
    end

    @include_activities = true
  end

end
