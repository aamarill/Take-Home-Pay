class StatementsController < ApplicationController
  include CalculationsHelper
  before_action :authenticate_user!

  def index
    verify_user(params)
    @statements = current_user.statements.order(created_at: :desc)
  end

  def new
    verify_user(params)

    @american_states  = american_states
    @marital_statuses = marital_statuses
    @FERS_codes       = fers_codes

    if !current_user.statements.empty?
      @statement = current_user.statements.order("created_at").last
    else
      @statement = Statement.new
    end
  end

  def create
    financial_attributes = params['statement'].permit!.to_hash
    @statement = Statement.new(financial_attributes)
    @statement.check_for_nil_values

    if params['commit'] == 'Save Calculation'
      current_user.statements << @statement
      current_user.save
    end
  end

  def show
    verify_user(params)
    @statement = get_statement(params)
  end

  def destroy
    @statement = get_statement(params)

    if @statement.destroy
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the statement."
      redirect_to action: :index
    end
  end

  private
  def get_statement(params)
    begin
    @statement = Statement.find(params['id'])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Statement not found"
      redirect_to :action => 'index'
    end
  end

  def verify_user(params)
    if params['user_id'].to_i != current_user.id
      flash[:notice] = "Invalid user "
      redirect_to user_statements_path(current_user.id)
    end
  end
end
