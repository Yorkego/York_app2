class ProfileController < ApplicationController
	 

  def show
  	if current_user.profile
  		@profile = current_user.profile
  	else
  		@profile = current_user.build_profile
  	end  	
  end

  
end
