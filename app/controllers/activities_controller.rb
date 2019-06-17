class ActivitiesController < ApplicationController

  def index
    @visible_lists = List.by_activity.first(30)

    @include_activities = true
  end

end
