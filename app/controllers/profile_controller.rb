class ProfileController < ApplicationController
	 

  def show
  	if Profile.find(params[:user_id])
  		@profile = Profile.find(params[:user_id])
  	else
  		@profile = User.find(params[:id]).build_profile
  	end  	
  end

  
end
