class ProfilesController < ApplicationController
	def show
  	if User.find(params[:id]).profile
  		@profile = Profile.find(params[:id])
  	else
  		@profile = User.find(params[:id]).build_profile
  	end  	
  end
end
