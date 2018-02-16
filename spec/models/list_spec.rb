require 'rails_helper'

RSpec.describe List, type: :model do
  before do
    @user = create(:user)
  end

  describe 'creation' do
    it 'can be created' do
      expect(build(:list, user: @user)).to be_valid
    end

    it 'cannot be created without name' do
      expect(build(:list, user: @user, :name => '')).to_not be_valid
    end

    it 'cannot be created with duplicate name on the same user' do
      create(:list, user: @user, :name => 'duplicate name')
      expect(build(:list, user: @user, :name => 'duplicate name')).to_not be_valid
    end

    it 'can have duplicate name when user is different' do
      create(:list, user: @user, :name => 'duplicate name')
      @user2 = create(:user)
      expect(build(:list, user: @user2, :name => 'duplicate name')).to be_valid
    end

    it 'cannot be created with tags that contain special characters' do
      expect(build(:list, user: @user, :tag_list => '%^&, ##vfd')).to_not be_valid
    end
  end
end
