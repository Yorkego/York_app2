require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'validation tests' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user1.friendships.create(attributes_for(:friendship, friend_id: @user2.id) )
      @user2.friendships.create(attributes_for(:friendship, friend_id: @user3.id, accepted: true) )
    end
    it 'should not create friendship that already created' do
      frindship = @user1.friendships.build(attributes_for(:friendship, friend_id: @user2.id) ).save
      expect(frindship).to eq(false)
    end

    it 'should not create friendship that already accepted' do
      frindship = @user2.friendships.build(attributes_for(:friendship, friend_id: @user3.id) ).save
      expect(frindship).to eq(false)
    end

    it 'should save successfully' do
      frindship = @user1.friendships.build(attributes_for(:friendship, friend_id: @user3.id) ).save
      expect(frindship).to eq(true)
    end
  end

  context 'assotiation tests' do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name("User") }
  end
end
