require 'rails_helper'
require 'stripe_mock'

headers = {
  'CONTENT_TYPE' => 'application/json',
  'ACCEPT' => 'application/json',
}

describe 'summaries api', type: :request do

  before do
    @user = create(:user)
    @user2 = create(:user)
    @list = create(:list, user: @user, access: 'contributors')
    @list2 = create(:list, user: @user2, access: 'contributors')
  end

  it 'can create summary for list' do
    login_as(@user, :scope => :user)
    post summaries_path, params: { list_id: @list.id, summary: { content: 'Test summary' } }.to_json, headers: headers
    expect(response.status).to eq 200
    expect(Summary.where(content: 'Test summary', list_id: @list.id)).to exist
  end

  it 'cant create summary for other user list' do
    login_as(@user2, :scope => :user)
    post summaries_path, params: { list_id: @list.id, summary: { content: 'Test summary' } }.to_json, headers: headers
    expect(response.status).to eq 401
  end

  it 'can update summary on list' do
    login_as(@user, :scope => :user)
    summary = create(:summary, user: @user, list: @list)
    put summary_path(summary), params: { summary: { content: 'Edited' } }.to_json, headers: headers
    expect(response.status).to eq 200
    expect(Summary.where(content: 'Edited', list_id: @list.id)).to exist
  end

  it 'cant update summaery on other user list' do
    login_as(@user, :scope => :user)
    summary = create(:summary, user: @user2, list: @list2)
    put summary_path(summary), params: { summary: { content: 'Edited' } }.to_json, headers: headers
    expect(response.status).to eq 401
  end

  it 'can delete summary from lits' do
    login_as(@user, :scope => :user)
    summary = create(:summary, user: @user, list: @list)
    delete summary_path(summary), headers: headers
    expect(response.status).to eq 200
  end

  it 'cant delete summary on other user list' do
    login_as(@user, :scope => :user)
    summary = create(:summary, user: @user2, list: @list2)
    delete summary_path(summary), headers: headers
    expect(response.status).to eq 401
  end

end
