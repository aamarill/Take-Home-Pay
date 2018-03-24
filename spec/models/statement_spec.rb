require 'rails_helper'

RSpec.describe Statement, type: :model do

  let(:empty_statement) { Statement.new}

  describe "empty statement" do
    it "has empty attributes" do
      expect(empty_statement).to have_attributes(parameters: {}, calculations: {})
    end
  end
end
