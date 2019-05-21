require 'rails_helper'
require 'stripe_mock'

headers = {
  'CONTENT_TYPE' => 'application/json',
  'ACCEPT' => 'application/json',
}

describe 'posts api', type: :request do

  before do
    @user = create(:user)
    @user2 = create(:user)
    @list = create(:list, user: @user, access: 'contributors')
    @list2 = create(:list, user: @user2, access: 'contributors')
  end

  it 'can create post for list' do
    login_as(@user, :scope => :user)
    post posts_path, params: { list_id: @list.id, post: { content: 'Test' } }.to_json, headers: headers
    expect(response.status).to eq 200
    expect(Post.where(content: 'Test', list_id: @list.id)).to exist
  end

  it 'cant create post for other user list' do
    login_as(@user2, :scope => :user)
    post posts_path, params: { list_id: @list.id, post: { content: 'Test' } }.to_json, headers: headers
    expect(response.status).to eq 401
  end

  it 'can update own post' do
    login_as(@user, :scope => :user)
    post = create(:post, user: @user, list: @list)
    put post_path(post), params: { post: { content: 'Test2' } }.to_json, headers: headers
    expect(response.status).to eq 200
    expect(Post.where(content: 'Test2', list_id: @list.id)).to exist
  end

  it 'cant update not owned post' do
    login_as(@user, :scope => :user)
    post = create(:post, user: @user2, list: @list2)
    put post_path(post), params: { post: { content: 'Test2' } }.to_json, headers: headers
    expect(response.status).to eq 401
  end

  it 'can delete own post' do
    login_as(@user, :scope => :user)
    post = create(:post, user: @user, list: @list)
    delete post_path(post), headers: headers
    expect(response.status).to eq 200
  end

  it 'cant delete not owned post' do
    login_as(@user, :scope => :user)
    post = create(:post, user: @user2, list: @list2)
    delete post_path(post), headers: headers
    expect(response.status).to eq 401
  end

end
