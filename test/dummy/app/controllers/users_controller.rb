class UsersController < ApplicationController
  
  def alert
    @user = User.new
  end
  
  def grid_system
    @user = User.new
  end
end
