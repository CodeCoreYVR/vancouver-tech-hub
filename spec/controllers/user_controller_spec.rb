require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) {FactoryGirl.create(:user)}
  let(:valid_attributes) {
    attributes_for(:user)
  }

  let(:invalid_attributes) {
    attributes_for(:user, email: "")
  }

  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "instantiates a user object and sets it to @user instance" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "#create" do
    context "successful create" do
      def send_valid_request
        post :create, user: valid_attributes
      end

      it "creates a user record in the database" do
        count_before = User.count
        send_valid_request
        count_after = User.count
        expect(count_after - count_before).to eq(1)
      end

      it "redirects to the home page" do
        send_valid_request
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash notice message" do
        send_valid_request
        expect(flash[:notice]).to be
      end

      it "sets the session user_id to the created user" do
        send_valid_request
        expect(session[:user_id]).to eq(User.last.id)
      end
    end

    context "unsuccessful create" do
      def send_invalid_request
        post :create, user: invalid_attributes
      end

      it "doesn't create a user record in the database" do
        count_before = User.count
        send_invalid_request
        count_after = User.count
        expect(count_after).to eq(count_before)
      end

      it "renders the new template" do
        send_invalid_request
        expect(response).to render_template(:new)
      end

      it "sets a flash alert message" do
        send_invalid_request
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#edit" do
    before do
      get :edit, id: user.id
    end
    it "renders edit template" do
      expect(response).to render_template(:edit)
    end

    it "finds the user id and set it to the @user param" do
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#update" do
    context "with valid attributes" do
      before do
        patch :update, id: user.id, user: {first_name: "validname"}
      end

      it "updates the record in the database" do
        expect(user.reload.first_name).to eq("validname")
      end

      it "redirects to the user show page" do
        expect(response).to redirect_to(user)
      end

      it "sends a flash notice" do
        expect(flash[:notice]).to be
      end
    end

    context "with invalid attributes" do
      before do
        patch :update, id: user.id, user: {email: "a"}
      end

      it "does not update record in the database" do
        expect(user.reload.email).not_to eq("a")
      end

      it "renders the edit page" do
        expect(response).to render_template(:edit)
      end

      it "shows a flash alert" do
        expect(flash[:alert]).to be
      end

    end
  end
end
