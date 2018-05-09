require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  describe "attributes" do
    it "has username and password attributes" do
      expect(user).to have_attributes(email: user.email, password:user.password)
    end
  end
end
