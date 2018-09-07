require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  login_user
  let(:user) { create(:user) }
  let(:post) { user.posts.create(attributes_for(:post)) }
  let(:comment) { post.comments.create(attributes_for(:comment, user_id: user)) }



   describe "POST #create" do
    context "with valid attributes" do
      it "creates a new comment" do
        expect{
          process :create, method: :post, params: { comment: attributes_for(:comment, user_id: user), post_id: post }
        }.to change(Comment,:count).by(1)
      end

      it "redirects to the new comment" do
        process :create, method: :post, params: { comment: attributes_for(:comment, user_id: user), post_id: post }
        expect(response).to redirect_to post
      end
    end
  end

  context 'DELETE #destroy' do
    before (:each) do
      @user2 = create(:user)
      sign_in @user2
      @post2 = @user2.posts.create(attributes_for(:post))
      @comment2 =  @post2.comments.new(attributes_for(:comment))
      @comment2.user_id = @user2.id
      @comment2.post_id = @post2.id
      @comment2.save
    end
    it 'removes post from table' do
      expect { delete :destroy, params: { id: @comment2.id, post_id: @post2.id } }.to change { Comment.count }.by(-1)
    end
    it "redirects to the root_url upon destroy" do
      delete :destroy, params: { id: @comment2.id, post_id: @post2.id }
      expect(response).to redirect_to @post2
    end
  end

end
