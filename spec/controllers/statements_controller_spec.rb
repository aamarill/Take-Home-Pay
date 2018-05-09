require 'rails_helper'

RSpec.describe StatementsController, type: :controller do

  let(:user) { create(:user)}
  let(:statement) { create(:statement, user: user) }

  before do
    # User must be signed in to modify Statements table in the database.
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index, params: {user_id: user.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new, params: {user_id: user.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "increases Statement count by 1" do
      statement_attributes = FactoryBot.attributes_for(:statement)
      expect{
        post :create, params: {user_id: user, statement: statement_attributes, commit: 'Save Calculation'}
      }.to change(Statement, :count).by(1)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      user_statement = user.statements.find(statement.id)
      get :show, params: {user_id: user.id, id: user_statement.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy" do
    it "decreases Statement count by 1" do
      user_statement = user.statements.find(statement.id)
      expect{
        delete :destroy, params: {user_id: user.id, id: user_statement.id}
      }.to change(Statement, :count).by(-1)
    end
  end
end
