require 'rails_helper'

RSpec.describe List, type: :model do
  before do
    @user = create(:user)
  end

  describe 'creation' do
    it 'can be created' do
      expect(build(:references, user: @user)).to be_valid
    end

    it 'cannot be created without name' do
      expect(build(:references, user: @user, :name => '')).to_not be_valid
    end

    it 'cannot be created with duplicate name on the same user' do
      create(:references, user: @user, :name => 'duplicate name')
      expect(build(:references, user: @user, :name => 'duplicate name')).to_not be_valid
    end

    it 'can have duplicate name when user is different' do
      create(:references, user: @user, :name => 'duplicate name')
      @user2 = create(:user)
      expect(build(:references, user: @user2, :name => 'duplicate name')).to be_valid
    end

    it 'cannot be created with tags that contain special characters' do
      expect(build(:references, user: @user, :tag_list => '%^&, ##vfd')).to_not be_valid
    end
  end
end
