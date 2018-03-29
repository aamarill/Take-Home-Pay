class CalculationsController < ApplicationController
  include CalculatorFormHelper

  def index
    @american_states  = american_states
    @marital_statuses = marital_statuses
    @FERS_codes       = fers_codes

    if user_signed_in?
      @parameters = current_user.parameter

    else
      @parameters = Parameter.new
    end
  end

  def create
    permitted_params = params.permit!
  p "financial_attributes:"
  p  financial_attributes = permitted_params.except(:utf8, :authenticity_token, :commit, :controller, :action)
  p "parameter object:"
  p  parameter = Parameter.new(financial_attributes.to_hash)

    if user_signed_in?
      current_user.parameter = parameter
      current_user.save
    end

    @statement = Statement.new(parameter)


    respond_to do |format|
      format.js
    end
  end
end
