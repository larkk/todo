module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_resource, only: [:vote_up, :vote_down, :unvote]
  end

  def vote_up
    authorize! :vote_up, @resource
    @resource.vote(current_user, 1)
    render :vote
  end

  def vote_down
    authorize! :vote_down, @resource
    @resource.vote(current_user, -1)
    render :vote
  end

  def unvote
    authorize! :unvote, @resource
    @resource.unvote(current_user)
    render :vote
  end

  private

    def set_resource
      @resource = controller_name.classify.constantize.find(params[:id])
    end
end