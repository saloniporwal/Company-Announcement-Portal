class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request
  before_action :set_post, only: [:show, :update]

  # Create a new post
  def create
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: @post, serializer: PostSerializer, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # View all posts
  def index
    posts = Post.includes(:user).order(created_at: :desc)
    render json: posts, each_serializer: PostSerializer, status: :ok
  end

  def show
    if authorized_user?
      render json: @post, serializer: PostSerializer, status: :ok
    else
      render json: @post, serializer: PostSerializer, status: :ok
    end
  end

  # Update a post , posts/:id 
  def update
    if authorized_user?
      if @post.update(post_params)
        render json: @post, serializer: PostSerializer, status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "You are not authorized to edit this post" }, status: :forbidden
    end
  end

  private

  def authorized_user?
    @post.user_id == @current_user.id
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Post not found" }, status: :not_found
  end
end
