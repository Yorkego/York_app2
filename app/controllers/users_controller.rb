class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end

  def invite
   	@user = User.find(params[:id])
  	current_user.invite @user		
		redirect_to @user, success: 'Added friend.'
  end
end
