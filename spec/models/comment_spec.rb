require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'assotiation tests' do
    it { should belong_to(:post).counter_cache(true) }
    it { should belong_to(:user) }
  end
  context 'created at desc scope' do
    before(:each) do
      @user1 = create(:user, username: "anna")
      @user2 = create(:user, username: "bob")
      @user3 = create(:user, username: "caren")
      @post1 = @user2.posts.create(attributes_for(:post, cached_votes_total: 30))
      @post2 = @user2.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3 = @user3.posts.create(attributes_for(:post, cached_votes_total: 50, comments_count: 2))
      @post4 = @user3.posts.create(attributes_for(:post, cached_votes_total: 20))
      @comment1 = @post3.comments.create(attributes_for(:comment, user_id: @user1.id))
      @comment2 = @post3.comments.create(attributes_for(:comment, user_id: @user1.id))
      @comment3 = @post4.comments.create(attributes_for(:comment, user_id: @user1.id))
    end
    it "return ordred comments" do
      expect(Comment.all.created_at_desc.first).to eq(@comment3)
    end
  end
end
