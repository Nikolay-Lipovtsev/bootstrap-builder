class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def alert
    new
  end
  
  def form
    new
  end
  
  def grid_system
    new
  end
end
