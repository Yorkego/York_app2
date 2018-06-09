class FriendshipsController < ApplicationController
	def invite
		current_user.invite @user		
		render user_path(@user.id), success: 'Added friend.'
	end
enda
