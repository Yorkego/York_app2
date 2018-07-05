class FriendshipsController < ApplicationController
  def create
     @friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Friend requested."
      redirect_back fallback_location: @user
    else
      flash[:error] = @friendship.errors.full_messages
      redirect_back fallback_location: @user
    end
  end

  def update
    @friendship = Friendship.find_by(user_id: params[:id], friend_id: current_user.id )
    @friendship.update(accepted: :true)
    if @friendship.save
      redirect_back fallback_location: @user, notice: "Successfully confirmed friend!"
    else
      redirect_back fallback_location: @user, error: @friendship.errors.full_messages
    end
  end

  def destroy
    if Friendship.find_by(user_id: params[:id],  friend_id: current_user.id).nil?
      @friendship = Friendship.find_by(user_id: current_user.id,  friend_id: params[:id])
    else
      @friendship = Friendship.find_by(user_id: params[:id], friend_id: current_user.id)
    end
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_back fallback_location: @user
  end
end
