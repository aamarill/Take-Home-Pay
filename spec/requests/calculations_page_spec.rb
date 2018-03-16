require 'rails_helper'

RSpec.describe "calculations page", :type => :request do
  it "renders index" do
    get "/calculations"
    expect(response).to render_template("calculations/index")
  end
end
