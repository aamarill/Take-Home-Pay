class StatementsController < ApplicationController
  include CalculationsHelper

  def index
    if !user_signed_in?
      redirect_to action: "new"
    else
      @statements = current_user.statements
    end
  end

  def new
    @american_states  = american_states
    @marital_statuses = marital_statuses
    @FERS_codes       = fers_codes

    if user_signed_in? && !current_user.statements.empty?
      @statement = current_user.statements.order("created_at").last
    else
      @statement = Statement.new
    end

  end

  def create
    financial_attributes = params['statement'].permit!.to_hash
    @statement = Statement.new(financial_attributes)
    @statement.check_for_nil_values

    if user_signed_in?
      current_user.statements << @statement
      current_user.save
    end

    respond_to do |format|
      format.js
    end
  end

  def show
    @statement = Statement.find(params[:id])
  end

  def destroy
    @statement = Statement.find(params[:id])

    if @statement.destroy
      flash[:notice] = "\"#{@statement.id}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      redirect_to action: :index
    end
  end


end
