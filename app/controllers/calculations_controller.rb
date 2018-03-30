class CalculationsController < ApplicationController
  include CalculationsHelper

  def index
    @american_states  = american_states
    @marital_statuses = marital_statuses
    @FERS_codes       = fers_codes

    if user_signed_in? && current_user.parameter
      @parameters = current_user.parameter
    else
      @parameters = Parameter.new
    end
  end

  def create
    financial_attributes = params['parameter'].permit!.to_hash
    @parameter = Parameter.new(financial_attributes)
    @parameter.check_for_nil_values

    if user_signed_in?
      current_user.parameter = @parameter
      current_user.save
    end

    respond_to do |format|
      format.js
    end
  end
end
