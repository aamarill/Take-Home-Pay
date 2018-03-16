require 'rails_helper'

RSpec.describe "welcome index page", :type => :request do
  it "renders" do
    get "/welcome/index"
    expect(response).to render_template("welcome/index")
  end

  it "is the root directory" do
    get "/"
    expect(response).to render_template("welcome/index")
  end
end
