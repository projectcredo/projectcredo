class ActivitiesController < ApplicationController

  def index
    if current_user
      @visible_lists =
        current_user.visible_lists.ranked.each do |list|
          list.pinned = current_user.homepage.lists.include?(list)
        end
    else
      @visible_lists = List.publicly_visible.ranked
    end
  end

end
