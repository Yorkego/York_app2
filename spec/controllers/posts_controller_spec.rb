require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  login_user
  let(:user) { create(:user) }
  let(:post) { user.posts.create(attributes_for(:post)) }
  context 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful # response.successful?
    end
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  context 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: post }
      expect(response).to be_successful
    end
    it "renders the #show view" do
      get :show, params: { id: post }
      expect(response).to render_template :show
    end
  end


  context 'GET #new' do
    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end
    it 'returns a fail response' do
      sign_out user
      get :new
      expect(response).to_not be_successful
    end
  end

   describe "POST #create" do
    context "with valid attributes" do
      it "creates a new post" do
        expect{
          process :create, method: :post, params: { post: attributes_for(:post), user_id: user.id }
        }.to change(Post,:count).by(1)
      end

      it "redirects to the new post" do
        process :create, method: :post, params: { post: attributes_for(:post), user_id: user.id }
        expect(response).to redirect_to Post.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new post" do
        expect{
          process :create, method: :post, params: { post: attributes_for(:post, title: ''), user_id: user.id }
        }.to_not change(Post,:count)
      end

      it "re-renders the new method" do
        process :create, method: :post, params: { post: attributes_for(:post, title: ''), user_id: user.id }
        expect(response).to render_template :new
      end
    end
  end

  context 'DELETE #destroy' do
    it 'removes post from table' do
      user2 = create(:user)
      sign_in user2
      post2 = user2.posts.create(attributes_for(:post))
      expect { delete :destroy, params: { id: post2 } }.to change { Post.count }.by(-1)
    end
    it "redirects to the root_url upon destroy" do
      delete :destroy, params: { id: post  }
      expect(response).to redirect_to root_url
    end
  end

end
