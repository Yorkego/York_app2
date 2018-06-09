class FriendshipsController < ApplicationController
	def invite
		current_user.invite @user		
		redirect_to user_path(@user.id), success: 'Added friend.'
	end
enda
