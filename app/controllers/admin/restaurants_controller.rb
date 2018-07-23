class Admin::RestaurantsController < ApplicationController
  puts "Admin::RestautantsController"
  before_action :authenticate_user!
  before_action :authenticate_admin
  def index

  end


end
