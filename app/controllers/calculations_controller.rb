class CalculationsController < ApplicationController
  def index
    @statement ||= Statement.new
  end

  def create
    @statement = Statement.new(params['calculation'])

    respond_to do |format|
      format.js
    end
  end
end
