require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = Fabricate(:user)
    @list = Fabricate(:list, user: @user)
  end

  test "should get index" do
    get root_url
    assert_response :success
    assert_includes @response.body, @list.name
  end

  test "should create list" do
    sign_in @user

    assert_difference('List.count', 1) do
      post lists_url(list: Fabricate.attributes_for(:list, user: @user))
    end
  end
end
