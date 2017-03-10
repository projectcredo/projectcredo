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

    assert_equal 201, @response.status
  end

  test "user cannot create an invalid highlight" do
    sign_in @user
    highlight_attributes = {
      highlight: {substring: 'this is not in the abstract'}
    }

    assert_difference('Highlight.count', 0) do
      post(paper_highlights_url(@paper, highlight_attributes), as: :json)
    end

    assert_equal 422, @response.status

    h = @paper.highlights.new(highlight_attributes[:highlight])
    h.valid?
    assert_equal h.errors.to_json, @response.body
  end
end
