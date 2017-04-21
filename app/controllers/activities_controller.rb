class ActivitiesController < ApplicationController

  def index
    if current_user
      @visible_lists = current_user.visible_lists.by_activity
    else
      @visible_lists = List.publicly_visible.by_activity
    end

    @include_activities = true
  end

end
