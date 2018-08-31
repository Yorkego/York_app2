class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @authors = User.with_summ_of_likes.filter(params[:filter])
    .paginate(:page => params[:page], :per_page => 25)
    .includes(:comments, :most_liked_post, :most_comentable_post)
  end

  def show
  end

  def edit
  end

  def update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
