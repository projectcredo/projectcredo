class Api::ActivitiesController < Api::ApplicationController
  def index
    @visible_lists = List.by_activity.first(30)
    @include_activities = true
    render 'jbuilders/_lists.json.jbuilder', {locals: {lists: @visible_lists}}
  end
end
