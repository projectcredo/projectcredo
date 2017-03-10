require "test_helper"

class HighlightsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = Fabricate(:user)
    @list = Fabricate(:list, user: @user)
    @paper = Fabricate(:paper)
    @list.papers << @paper
  end

  test "user can create a highlight" do
    sign_in @user

    assert_difference('Highlight.count', 1) do
      post(
        paper_highlights_url(@paper, {
            highlight: {substring: @paper.abstract[0, @paper.abstract.length/2]}
          }
        ),
        as: :json
      )
    end
  end
end
