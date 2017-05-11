class ActivitiesController < ApplicationController

  def index
    if current_user
      @visible_lists = current_user.visible_lists.by_activity.first(30)
    else
      @visible_lists = List.publicly_visible.by_activity.first(30)
    end

    @include_activities = true
  end

end
