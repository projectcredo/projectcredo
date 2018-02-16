require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = Fabricate(:user)
    @list = Fabricate(:references, user: @user)
  end

  test "guest should get index" do
    get lists_path
    assert_response :success
    assert_includes @response.body, @list.name
  end

  test 'guest should see public lists' do
    user_2 = Fabricate(:user)
    list_2 = Fabricate(:references, user: user_2)

    get lists_path

    assert_includes @response.body, @list.name
    assert_includes @response.body, list_2.name
  end

  test "user should create list" do
    sign_in @user

    assert_difference('List.count', 1) do
      post lists_url(references: Fabricate.attributes_for(:references, user: @user))
    end
  end

  test "user should see other user's public list" do
    user_2 = Fabricate(:user)
    list_2 = Fabricate.build(:references, user: user_2)

    sign_in @user
    get lists_path

    refute_includes @response.body, list_2.name
    list_2.save

    get lists_path
    assert_includes @response.body, list_2.name
  end

  test "user should not see other user's private list" do
    user_2 = Fabricate(:user)
    list_2 = Fabricate(:references, user: user_2, visibility: :private)

    sign_in @user
    get lists_path

    refute_includes @response.body, list_2.name
  end

  test "user should see own private lists" do
    list_2 = Fabricate(:references, user: @user, visibility: :private)

    sign_in @user
    get lists_path

    assert_includes @response.body, list_2.name
  end
end
