class PostsController < ApplicationController
  before_action :logged_in?, only: [:create, :destroy]
  def create
    @post = current_user.posts.build(post_params)
        if @post.save
          flash[:success] = "Post created!"
          redirect_to '/dashboard'
        else
          flash[:danger] = "Error in creating post"
          redirect_to :back
        end
  end
  def destroy

  end
  def show
    @user = current_user
    @posts = @user.posts.paginate(page: params[:page])
  end

private

  def post_params
    params.require(:post).permit(:content, :title)
  end
end
