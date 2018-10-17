require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'validation tests' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }

    it 'should save successfully' do
      user = create(:user)
      post = user.posts.build(attributes_for(:post)).save
      expect(post).to eq(true)
    end
  end

  context 'assotiation tests' do
    it { should belong_to(:user).counter_cache(true) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_one(:last_comment).class_name('Comment') }
  end

  context 'order by scope tests' do
    before(:each) do
      @user1 = create(:user, username: "anna")
      @user2 = create(:user, username: "bob")
      @user3 = create(:user, username: "caren")
      @post1 = @user2.posts.create(attributes_for(:post, cached_votes_total: 30))
      @post2 = @user2.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3 = @user3.posts.create(attributes_for(:post, content: 'big text thfghfhfhghjgjk;lfjgfk;djgkdfjgdfkgdfflk', cached_votes_total: 50))
      @post4 = @user3.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3.comments.create()
      @post3.comments.create()
      @post4.comments.create()
    end
    it "return posts ordered by created_at" do
      expect(Post.order_by('created_at', 'desc').first).to eq(@post4)
    end
    it "return posts ordered by username" do
      expect(Post.order_by('username', 'desc').first.user.username).to eq("caren")
    end
    it "return posts ordered by votes" do
      expect(Post.order_by('votes', 'desc').first).to eq(@post3)
    end
    it "return posts ordered by lenght" do
      expect(Post.order_by('lenght', 'desc').first).to eq(@post3)
    end
    # it "return posts ordered by comment_counts" do
    #   expect(Post.order_by('comment_counts', 'desc').first).to eq(@post3)
    # end
    # it "return posts ordered by comment_last" do
    #   expect(Post.order_by('comment_last', 'desc').first).to eq(@post4)
    # end
  end

  context 'filter tests' do
    before(:each) do
      @user1 = create(:user, username: "anna")
      @user2 = create(:user, username: "bob")
      @user3 = create(:user, username: "caren")
      @post1 = @user2.posts.create(attributes_for(:post, cached_votes_total: 30))
      @post2 = @user2.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3 = @user3.posts.create(attributes_for(:post, content: 'big text', cached_votes_total: 50))
      @post4 = @user3.posts.create(attributes_for(:post, cached_votes_total: 20))
      @post3.comments.create()
      @post3.tags.create(name: "test")
      @post3.comments.create()
      @post4.comments.create()
    end
    it "return posts with keyword big" do
      expect(Post.filter(category: "created_at", direction: "desc", keyword: "big", author: "").first).to eq(@post3)
    end
    it "return caren posts" do
      expect(Post.filter(category: "created_at", direction: "desc", keyword: "", author: "caren").first.user.username).to eq("caren")
    end
    # it "return posts with tag test" do
    #   # byebug
    #   expect(Post.filter(category: "created_at", direction: "desc", keyword: "", author: "", tag_ids: ["1"]).includes(:last_comment, :tags, :user).first.tags.first.name).to eq("test")
    # end
  end
end
