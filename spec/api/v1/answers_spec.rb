require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create :access_token }
  let(:question) { create :question }
  let!(:answers) { create_list :answer, 2, :with_comments, :with_attachments, question: question }
  let(:answer) { answers.first }
  let(:resource) { answer }
  let(:comment) { answer.comments.first }
  let(:attachment) { answer.attachments.first }
  let(:attributes) { %w(id body created_at updated_at) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:path) { 'answers/0' }

      before { get "/api/v1/questions/#{question.id}/answers",
                   format: :json,
                   access_token: access_token.token }

      it_behaves_like 'successful request'
      it_behaves_like 'api resource with attributes'

      it 'returns a list of resources' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:path) { 'answer' }
    let(:size) { 1 }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
                   format: :json,
                   access_token: access_token.token }

      it_behaves_like 'successful request'
      it_behaves_like 'api commentable'
      it_behaves_like 'api attachable'
      it_behaves_like 'api resource with attributes'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:post_attributes) {
        {
            answer: attributes_for(:answer),
            question_id: question,
            format: :json,
            access_token: access_token.token
        }
      }

      it 'returns 201 status code' do
        post "/api/v1/questions/#{question.id}/answers", post_attributes
        expect(response.status).to eq 201
      end

      it 'saves a question to the db' do
        expect{ post "/api/v1/questions/#{question.id}/answers", post_attributes }.to change(question.answers, :count).by(1)
      end
    end
  end

  def do_request(options = {})
    post "/api/v1/questions/#{question.id}/answers",
         {
             answer: attributes_for(:answer),
             question_id: question
         }.merge(options)
  end
end
