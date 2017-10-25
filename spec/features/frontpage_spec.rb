require 'rails_helper'

describe 'front page' do

  before do
    @user = create(:user)
    @list = create(:list, user: @user)
    @activity = create(:activity, user: @user, actable: @list, activity_type: "created")
  end

  it 'should set activity index for guest' do
    visit root_path
    expect(page.body).to include(@list.name)
    expect(page.body).to include(@activity.activity_type)
  end

end
