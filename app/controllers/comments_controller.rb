class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable
  respond_to :js, :json, :html

  def new
    @comment = Comment.new
  end

  def create
    session[:return_to] ||= request.referer
    @comment = @post.comments.new comment_params
    @comment.user_id = current_user.id
    @comment.post_id = @post.id

    if @comment.save
      @comment.move_to_child_of(Comment.find(params[:parent_id])) unless params[:parent_id].blank?
      redirect_to session.delete(:return_to), notice: 'Your comment was successfully posted!'
    else
      redirect_to session.delete(:return_to), notice: "Your comment wasn't posted!"
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: 'Your comment was successfully deleted!' }
      format.json
      format.js { render :template => 'comments/destroy.js.erb', :layout => false  }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def find_commentable
    @post = Post.find(params[:post_id])
  end
end