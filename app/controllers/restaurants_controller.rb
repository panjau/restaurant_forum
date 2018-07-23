class RestaurantsController < ApplicationController
  puts "RestaurantsController"
  before_action :authenticate_user!
  def index
  end
end
