require 'rails_helper'

describe AttachmentsController do

  describe 'DELETE #destroy' do
    let!(:author) { create :user }
    let!(:another_user) { create :user }
    let!(:question) { create :question,
                             :with_attachments,
                             user: author }
    let!(:attachment) { question.attachments.first }
    let!(:another_users_question) { create :question,
                                           :with_attachments,
                                           user: another_user }
    let!(:another_users_attachment) { another_users_question.attachments.first }
    let!(:delete_params) {{ id: attachment, question_id: question, format: :js }}

    before { sign_in(author) }

    it 'assigns attachment to @attachment' do
      delete :destroy, delete_params
      expect(assigns(:attachment)).to eq attachment
    end

    it 'assigns attachable to @attachable' do
      delete :destroy, delete_params
      expect(assigns(:attachable)).to eq question
    end

    it "deletes author's attachment" do
      expect{ delete :destroy, delete_params }
          .to change(Attachment, :count).by(-1)
    end

    it "can not delete another user's attachment" do
      expect{ delete :destroy, id: another_users_attachment, question_id: another_users_question, format: :js }
          .not_to change(Attachment, :count)
    end

    it 'renders destroy template' do
      delete :destroy, delete_params
      expect(response).to render_template :destroy
    end
  end
end
