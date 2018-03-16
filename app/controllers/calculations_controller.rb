class CalculationsController < ApplicationController

  def index
    @test = "hello world!"
  end

  def create
    p "Hello there!"
    @test = "hello again!"

    render "index"
  end
end
