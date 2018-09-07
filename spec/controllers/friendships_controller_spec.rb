require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  before (:each) do
    sign_in user
    @user = user2
  end

  #  describe "POST #create" do
  #   context "with valid attributes" do
  #     it "creates a new friendship" do
  #       expect{
  #         process :create, method: :post, params: { friend_id: user2 }
  #       }.to change(Comment,:count).by(1)
  #     end

  #     it "redirects to the " do
  #       process :create, method: :post, params: { friend_id: user2 }
  #       expect(response).to redirect_to user2
  #     end
  #   end
  # end

  # context 'DELETE #destroy' do
  #   before (:each) do
  #     @user2 = create(:user)
  #     sign_in @user2
  #     @post2 = @user2.posts.create(attributes_for(:post))
  #     @comment2 =  @post2.comments.new(attributes_for(:comment))
  #     @comment2.user_id = @user2.id
  #     @comment2.post_id = @post2.id
  #     @comment2.save
  #   end
  #   it 'removes post from table' do
  #     expect { delete :destroy, params: { id: @comment2.id, post_id: @post2.id } }.to change { Comment.count }.by(-1)
  #   end
  #   it "redirects to the root_url upon destroy" do
  #     delete :destroy, params: { id: @comment2.id, post_id: @post2.id }
  #     expect(response).to redirect_to @post2
  #   end
  # end

end
