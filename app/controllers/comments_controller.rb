class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request, except: [:index, :show]
  before_action :set_post

  # Create a comment #/users/user_id/comments
  def create
    commentable = find_commentable
    comment = commentable.comments.build(comment_params)
    comment.user = @current_user
    if comment.save
      render json: { message: 'Comment created successfully', comment: comment }, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # All comments of a post   #/posts/post_id/comments
  def index
    comments = @commentable.comments.where(parent_id: nil).includes(replies: { replies: { replies: { replies: :user } } }).order(created_at: :asc)
    render json: comments, each_serializer: CommentSerializer, status: :ok
  end

  # Show comments of a post   #/posts/post_id/comments/:id
  def show
    comment = @commentable.comments.find(params[:id])
    render json: comment, serializer: CommentSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ["Comment not found"] }, status: :not_found
  end

  private

  def set_post
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def find_commentable
    begin
      params[:commentable_type].constantize.find(params[:commentable_id])
    rescue NameError
      render json: { errors: ["Invalid commentable type"] }, status: :unprocessable_entity and return
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ["Commentable not found"] }, status: :not_found and return
    end
  end
end
