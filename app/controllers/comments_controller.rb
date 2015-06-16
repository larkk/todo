class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action :publish_to_comments, only: :create

  authorize_resource

  respond_to :json, :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)), template: 'comments/submit')
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_commentable
      commentable = params[:commentable].classify.constantize
      id = (params[:commentable].singularize + '_id').to_sym
      @commentable = commentable.find(params[id])
    end

    def publish_to_comments
      PrivatePub.publish_to channel, comment: render_to_string(template: 'comments/submit') if @comment.valid?
    end

    def channel
      "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }/comments"
    end
end
