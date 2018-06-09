class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end

  def invite
  	current_user.invite @user		
		render user_path(@user.id), success: 'Added friend.'
  end
end
