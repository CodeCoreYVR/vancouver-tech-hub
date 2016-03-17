require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) {create(:user)}
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context 'with existing email' do
      before do
        post :create, password_reset: {email: user.email }
      end
      it 'redirects use to the root path' do
        expect(response).to redirect_to(root_path)
      end
      it 'sends a reset password email' do
        expect(UserMailer).to receive(:password_reset).with(user)
      end
    end
    context 'without existing email' do
    end
  end
end
