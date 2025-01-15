class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request
  before_action :set_post

  # Create a comment
  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Show comments of a post
  def index
    comments = @post.comments.where(parent_id: nil).includes(replies: { replies: { replies: { replies: :user } } }) .order(created_at: :asc)
    render json: comments, each_serializer: CommentSerializer, status: :ok
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
