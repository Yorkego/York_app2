require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  login_user
  let(:user) { create(:user) }

  it "should have a current_user" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).to_not eq(nil)
  end

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
      get :show, params: { id: user }
      expect(response).to be_successful
    end
    it "renders the #show view" do
      get :show, params: { id: user }
      expect(response).to render_template :show
    end
  end

end
