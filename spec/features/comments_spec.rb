require 'rails_helper'
require 'stripe_mock'

headers = {
  'CONTENT_TYPE' => 'application/json',
  'ACCEPT' => 'application/json',
}

describe 'comments api', type: :request do

  before do
    @user = create(:user)
    @list = create(:list, user: @user)
  end

  it 'creates comment for list' do
    login_as(@user, :scope => :user)
    post comments_path, params: { comment: { content: 'Test', commentable_type: 'List', commentable_id: @list.id, list_id: @list.id } }.to_json, headers: headers
    expect(response.status).to eq 200
    expect(Comment.where(content: 'Test', commentable_type: 'List', commentable_id: @list.id)).to exist
  end

  it 'updates own comment' do
    login_as(@user, :scope => :user)
    comment = create(:comment, user: @user, commentable_type: 'List', commentable_id: @list.id, list_id: @list.id)
    put comment_path(comment), params: { comment: { content: 'Test2' } }.to_json, headers: headers
    expect(response.status).to eq 200
    expect(Comment.where(content: 'Test2', commentable_type: 'List', commentable_id: @list.id)).to exist
  end

  it 'cant update not owned comment' do
    login_as(@user, :scope => :user)
    other_user = create(:user)
    comment = create(:comment, user: other_user, commentable_type: 'List', commentable_id: @list.id, list_id: @list.id)
    put comment_path(comment), params: { comment: { content: 'Test2' } }.to_json, headers: headers
    expect(response.status).to eq 401
  end

  it 'deletes own comment' do
    login_as(@user, :scope => :user)
    comment = create(:comment, user: @user, commentable_type: 'List', commentable_id: @list.id, list_id: @list.id)
    delete comment_path(comment), headers: headers
    expect(response.status).to eq 204
  end

  it 'cant delete not owned comment' do
    login_as(@user, :scope => :user)
    other_user = create(:user)
    comment = create(:comment, user: other_user, commentable_type: 'List', commentable_id: @list.id, list_id: @list.id)
    delete comment_path(comment), headers: headers
    expect(response.status).to eq 401
  end

end
