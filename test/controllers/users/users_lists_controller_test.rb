require 'test_helper'

class Users::ListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = Fabricate(:user)
    @list = Fabricate(:list, user: @user)
    require_js
  end

  test "guest should get index" do
    get user_lists_path(@user)
    assert_response :success
    assert_includes @response.body, @list.name
  end

  test "user should see other user's public list" do
    user_2 = Fabricate(:user)
    list_2 = Fabricate.build(:list, user: user_2)

    sign_in @user
    get user_lists_path(user_2)

    refute_includes @response.body, list_2.name
    list_2.save

    get user_lists_path(user_2)
    assert_includes @response.body, list_2.name
  end

  test "user should not see other user's private list" do
    user_2 = Fabricate(:user)
    list_2 = Fabricate(:list, user: user_2, visibility: :private)

    sign_in @user
    get user_lists_path(user_2)

    refute_includes @response.body, list_2.name
  end

  test "user should see own private lists" do
    list_2 = Fabricate(:list, user: @user, visibility: :private)

    sign_in @user
    get user_lists_path(@user)

    assert_includes @response.body, list_2.name
  end

  test 'updates user list' do
    sign_in @user
    patch(user_list_path(@user, @list), params: {list: {name: 'Updated list name'}})
    @list.reload
    assert_equal @list.name, 'Updated list name'
  end

  test 'destroys user list' do
    sign_in @user
    delete user_list_path(@user, @list)
    refute List.exists?(id: @list.id)
  end
end
