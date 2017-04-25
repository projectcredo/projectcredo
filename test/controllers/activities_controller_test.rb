require 'test_helper'

class ActivitesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = Fabricate(:user)
    @list = Fabricate(:list, user: @user)
    @activity = Fabricate(:activity, user: @user, actable: @list, activity_type: "created")
  end

  test "guest should get activity index" do
    get root_path
    assert_response :success
    assert_includes @response.body, @list.name
    assert_includes @response.body, @activity.activity_type
  end

  test 'guest should see public activities' do
    user_2 = Fabricate(:user)
    list_2 = Fabricate(:list, user: user_2)
    activity_2 = Fabricate(:activity, user: user_2, actable: list_2, activity_type: "created")

    get root_path

    assert_includes @response.body, @list.name
    assert_includes @response.body, list_2.name
  end

  test "user should see other user's public list" do
    user_2 = Fabricate(:user)
    list_2 = Fabricate.build(:list, user: user_2)

    sign_in @user
    get root_path

    refute_includes @response.body, list_2.name
    list_2.save
    activity_2 = Fabricate(:activity, user: user_2, actable: list_2, activity_type: "created")

    get root_path
    assert_includes @response.body, list_2.name
  end

  test "user should not see other user's private list" do
    user_2 = Fabricate(:user)
    list_2 = Fabricate(:list, user: user_2, visibility: :private)
    activity_2 = Fabricate(:activity, user: user_2, actable: list_2, activity_type: "created")


    sign_in @user
    get root_path

    refute_includes @response.body, list_2.name
  end

  test "user should see own private lists" do
    list_2 = Fabricate(:list, user: @user, visibility: :private)
    activity_2 = Fabricate(:activity, user: @user, actable: list_2, activity_type: "created")

    sign_in @user
    get root_path

    assert_includes @response.body, list_2.name
  end
end
