require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }

  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "with valid credentials" do
      before { post :create, email: user.email, password: user.password }

      it "sets the session user_id to the user with the passed email" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash notice message" do
        expect(flash[:notice]).to be
      end
    end
    context "with invalid credentials" do
      before { post :create, email: user.email, password: user.password + "A" }
      it "renders the sign in page (new template)" do
        expect(response).to render_template(:new)
      end

      it "sets a flash alert message" do
        expect(flash[:alert]).to be
      end

      it "doesn't set session user_id if email is correct and password is wrong" do
        expect(session[:user_id]).to eq(nil)
      end
    end
  end

  describe "#destroy" do
    before do
      request.session[:user_id] = user.id
      delete :destroy
    end

    it "sets the session user_id to nil" do
      expect(session[:user_id]).not_to be
    end

      it "redirects to the root path" do
        expect(response).to redirect_to(:root)
      end
    it "sets a flash notice message" do
      expect(flash[:notice]).to be
    end

  end

end
