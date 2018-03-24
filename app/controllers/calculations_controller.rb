class CalculationsController < ApplicationController
  def index
    @statement ||= Statement.new
  end

  def create
    @statement = Statement.new(params['calculation'])
    render "index"
  end
end
