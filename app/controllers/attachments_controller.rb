class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment
  before_action :set_attachable

  authorize_resource

  def destroy
    @attachment.destroy!
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end
    def set_attachable
      @attachable = @attachment.attachable_type.constantize.find(@attachment.attachable_id)
    end
end
