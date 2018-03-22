require 'rails_helper'

RSpec.describe CalculationsController do
  describe "GET index" do
    it "renders index" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST create" do
    it "renders index" do
      post :create
      expect(response).to render_template("index")
    end
  end
end
