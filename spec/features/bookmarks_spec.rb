require 'rails_helper'

describe 'bookmarks page' do

  before do
    @user = create(:user)
    @list = create(:list, user: @user)
    @paper1 = create(:paper)
    @paper2 = create(:paper)
    @paper1.bookmark(user: @user)
    @paper2.bookmark(user: @user)

    login_as(@user, :scope => :user)
  end

  it 'should see added papers list on bookmarks page' do
    visit bookmarks_path
    expect(page.body).to include(@paper1.title)
    expect(page.body).to include(@paper2.title)
  end

end
