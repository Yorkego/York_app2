class ProfileController < ApplicationController
	 

  def show
  	if User.find(params[:id]).profile == nil  		
  		@profile = User.find(params[:id]).build_profile
  	else
  		@profile = Profile.find(params[:id])
  	end  	
  end

  
end
