class FriendshipsController < ApplicationController
	ALLOWED_FRIENDSHIP_ACTIONS = %w('invite' 'approve' 'remove_friendship' 'block', 'unblock')

  before_action :authenticate_user!

  def index
    @friends = current_user.friends
    @pending_invited_by = current_user.pending_invited_by
    @pending_invited = current_user.pending_invited
  end

  def update
    @friend = User.find(params[:id])
    current_user.send(friendship_action, @friend) if friendship_action
    redirect_to  @friend
  end

private

  def friendship_action
    if fa = params[:friendship_action]
      return fa if ALLOWED_FRIENDSHIP_ACTIONS.include?(fa)
    end
  end
end
