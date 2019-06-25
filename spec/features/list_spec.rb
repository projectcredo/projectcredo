require 'rails_helper'

describe 'lists' do

  before do
    @user = create(:user)
    @list = create(:list, user: @user)
    @list2 = create(:list, user: @user)
    @list_private = create(:list, user: @user)

    @other_user = create(:user)

    @user2 = create(:user)
    @user2_list = create(:list, user: @user2)
    @user2_private_list = create(:list, user: @user2)
  end

  #
  # User lists index page
  #
  describe 'index' do
    before do
      visit user_lists_path @user
    end

    context 'when logged out' do
      it 'can be reached successfully' do
        expect(page.status_code).to eq(200)
      end

      it "should show all lists" do
        expect(page.body).to include(@list.name)
        expect(page.body).to include(@list2.name)
      end
    end

    context 'when logged in' do
      before do
        login_as(@user, :scope => :user)
        visit user_lists_path @user
      end

      it 'can be reached successfully' do
        expect(page.status_code).to eq(200)
      end

      it "should show all lists" do
        expect(page.body).to include(@list.name)
        expect(page.body).to include(@list2.name)
        expect(page.body).to include(@list_private.name)
      end
    end
  end

  #
  # Single list page
  #
  describe 'show' do
    before do
      visit user_list_path @user, @list
    end

    context 'when logged out' do
      it 'can be reached successfully' do
        expect(page.status_code).to eq(200)
      end

      it 'should show board name and details' do
        expect(page.body).to include(@list.name)
        expect(page.body).to include(@list.description)
      end
    end

    context 'when logged in' do
      before do
        login_as(@user, :scope => :user)
        visit user_list_path @user, @list
      end

      it 'can be reached successfully' do
        expect(page.status_code).to eq(200)
      end

      it 'should show board name and details' do
        expect(page.body).to include(@list.name)
        expect(page.body).to include(@list.description)
      end

      it 'should not show other user private list' do
        pending('private boards should not be visible')
        visit user_list_path @user2, @user2_private_list

        expect(page.status_code).to eq(302)
      end
    end
  end

  #
  # Create a list
  #
  describe 'create', type: :request do

    context 'when logged out' do
      it 'should redirect to sign_in page' do
        get new_list_path
        expect(response.status).to eq 302
      end
    end

    context 'when logged in' do
      before do
        post new_user_session_path, params: {user: {login: @user.email, password: '123456'}}
      end

      it 'can be reached successfully' do
        get new_list_path
        expect(response.status).to eq 200
      end

      it 'can be created with valid data', type: :request do
        data = {
          name: 'Some name',
          description: 'Some description',
          tag_list: 'tag1, tag2',
        }

        expect do
          post lists_path, params: {list: data}
        end.to change {
          List.count
        }.by(1)

        expect(List.last).to have_attributes(data.slice(:name, :description, :access))
      end

    end

  end

  #
  # Update list
  #
  describe 'update', type: :request do

    context 'when logged out' do
      it 'should redirect to sign_in page on edit page' do
        get edit_user_list_path(@user, @list)
        expect(response.status).to eq 302
      end

      it 'should redirect to sign_in page on update request' do
        put user_list_path(@user, @list)
        expect(response.status).to eq 302
      end
    end

    context 'when logged in as owner' do
      before do
        post new_user_session_path, params: {user: {login: @user.email, password: '123456'}}
      end

      it 'edit page can be reached successfully' do
        get edit_user_list_path(@user, @list)
        expect(response.status).to eq 200
      end

      it 'can be updated with valid data' do
        data = {
          name: 'Some name updated',
          description: 'Some description updated',
          tag_list: 'tag1, tag2, tag3',
        }

        put user_list_path(@user, @list), params: {list: data}

        expect(@list.reload).to have_attributes(data.slice(:name, :description, :access))
      end

    end

  end

  #
  # Delete list
  #
  describe 'delete', type: :request do

    context 'when logged out' do
      it 'should not delete' do
        expect{
          delete user_list_path(@user, @list)
        }.to_not change(List, :count)
      end
    end

    context 'when logged in' do
      before do
        post new_user_session_path, params: {user: {login: @user.email, password: '123456'}}
      end

      it 'owner can delete list' do
        expect{
          delete user_list_path(@user, @list)
        }.to change(List, :count).by(-1)
      end

    end

    context 'when logged in as non owner' do
      before do
        post new_user_session_path, params: {user: {login: @user2.email, password: '123456'}}
      end

      it 'can not delete list' do
        expect{
          delete user_list_path(@user, @list)
        }.to_not change(List, :count)
      end

    end

  end

end
