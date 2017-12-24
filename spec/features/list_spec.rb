require 'rails_helper'

describe 'lists' do

  before do
    @user = create(:user)
    @list = create(:list, user: @user)
    @list2 = create(:list, user: @user)
    @list_private = create(:list, user: @user, visibility: :private)

    @user2 = create(:user)
    @user2_list = create(:list, user: @user2, visibility: :private)
    @user2_private_list = create(:list, user: @user2, visibility: :private)
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

      it "should show all user's public lists" do
        expect(page.body).to include(@list.name)
        expect(page.body).to include(@list2.name)
      end

      it "should not show user's private lists" do
        expect(page.body).to_not include(@list_private.name)
      end

      it 'should not show other users lists' do
        expect(page.body).to_not include(@user2_list.name)
        expect(page.body).to_not include(@user2_private_list.name)
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

      it "should show all user's lists" do
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

      it 'should not show private list' do
        pending('private boards should not be visible')
        visit user_list_path @user, @list_private

        expect(page.status_code).to eq(302)
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

      it 'should not show other user private list' do
        pending('private boards should not be visible')
        visit user_list_path @user2, @user2_private_list

        expect(page.status_code).to eq(302)
      end
    end
  end


end
