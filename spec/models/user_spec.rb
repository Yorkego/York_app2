require 'rails_helper'

RSpec.describe User, type: :model do
  context 'assotiation tests' do
    it { should have_many(:friendships) }
    it { should have_many(:received_friendships).class_name("Friendship").with_foreign_key("friend_id") }
    it { should have_many(:active_friends).conditions(friendships: { accepted: true} ).source(:friend).through(:friendships) }
    it { should have_many(:received_friends).conditions(friendships: { accepted: true} ).source(:user).through(:received_friendships) }
    it { should have_many(:pending_friends).conditions(friendships: { accepted: false} ).source(:friend).through(:friendships) }
    it { should have_many(:requested_friendships).conditions(friendships: { accepted: false} ).source(:user).through(:received_friendships) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_one(:most_liked_post).order("cached_votes_total desc").class_name("Post") }
    it { should have_one(:most_comentable_post).order("comments.count desc").class_name("Post") }
  end

  context 'most_liked_post assotiation tests' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @post1 = @user2.posts.create(attributes_for(:post, cached_votes_total: 30))
      @post2 = @user2.posts.create(attributes_for(:post, cached_votes_total: 20))
    end
    it "return users that have posts" do
      # byebug
      expect(@user2.most_liked_post).to eq(@post1)
    end
  end

  # context 'most_comentable_post assotiation tests' do
  #   before(:each) do
  #     @user1 = create(:user)
  #     @user2 = create(:user)
  #     @post1 = @user2.posts.create(attributes_for(:post, comments_count: 2))
  #     @post2 = @user2.posts.create(attributes_for(:post))
  #     @post1.comments.create()
  #     @post1.comments.create()
  #   end
  #   it "return users that have posts" do
  #     # byebug
  #     expect(@user2.most_comentable_post).to eq(@post1)
  #   end
  # end

  context 'authors scope tests' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user2.posts.create(attributes_for(:post))
    end
    it "return users that have posts" do
      expect(User.authors).to eq([@user2])
    end
  end

  context 'with_summ_of_likes scope tests' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @post1 = @user2.posts.create(attributes_for(:post, cached_votes_total: 30))
      @post2 = @user2.posts.create(attributes_for(:post, cached_votes_total: 20))
    end
    it "return user with sum_votes" do
      expect(User.with_summ_of_likes.second.sum_votes).to eq(50)
    end
  end

  context 'order_authors scope tests' do
    before(:each) do
      @user1 = create(:user, username: "anna")
      @user2 = create(:user, username: "bob")
      @user3 = create(:user, username: "caren")
      @post1 = @user2.posts.create(attributes_for(:post, cached_votes_total: 30))
      @post2 = @user2.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3 = @user3.posts.create(attributes_for(:post, cached_votes_total: 50, comments_count: 2))
      @post4 = @user3.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3.comments.create()
      @post3.comments.create()
      @post4.comments.create()
    end
    it "return users ordered by create at" do
      expect(User.all.order_authors('created_at', 'desc').first).to eq(@user3)
    end
    it "return users ordered by username" do
      expect(User.all.order_authors('username', 'desc').first).to eq(@user3)
    end
    # it "return users ordered by votes" do
    #   expect(User.all.with_summ_of_likes.order_authors('votes', 'desc').first).to eq(@user3)
    # end
    # it "return users ordered by author_votes" do
    #   # byebug
    #   expect(User.all.with_summ_of_likes.order_authors('author_votes', 'desc').first).to eq(@user3)
    # end
    it "return users ordered by comment_counts" do
      expect(User.authors.with_summ_of_likes.order_authors('comment_counts', 'desc').first).to eq(@user3)
    end
    # it "return users ordered by comment_last" do
    #   # byebug
    #   expect(User.authors.with_summ_of_likes.order_authors('comment_last', 'asc').first).to eq(@user3)
    # end
  end
  context 'filter tests' do
    before(:each) do
      @user1 = create(:user, username: "anna")
      @user2 = create(:user, username: "bob")
      @user3 = create(:user, username: "caren")
      @post1 = @user2.posts.create(attributes_for(:post, cached_votes_total: 30))
      @post2 = @user2.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3 = @user3.posts.create(attributes_for(:post, cached_votes_total: 50, comments_count: 2))
      @post4 = @user3.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3.comments.create()
      @post3.comments.create()
      @post4.comments.create()
    end
    it "return user caren" do
      expect(User.with_summ_of_likes.filter(category: "created_at", direction: "ASC", username: "caren").first).to eq(@user3)
    end
  end


end
