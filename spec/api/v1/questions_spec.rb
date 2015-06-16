require 'rails_helper'

describe 'Questions API' do
  let(:user) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: user.id }
  let!(:questions) { create_list :question, 2 }
  let(:resource) { question }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:question) { questions.first }
      let!(:answer) { create :answer, question: question }
      let(:resource) { question }
      let(:attributes) { %w(id title body created_at updated_at) }
      let(:path) { 'questions/0'}
      let(:size) { 2 }

      before { get '/api/v1/questions',
                   format: :json,
                   access_token: access_token.token }

      it_behaves_like 'successful request'
      it_behaves_like 'api resource with attributes'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        let(:resource) { answer }
        let(:attributes) { %w(id body created_at updated_at user_id best) }
        let(:path) { 'questions/0/answers/0'}
        let(:size) { 1 }

        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        it_behaves_like 'api resource with attributes'
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: question }
    let!(:attachment) { create :attachment, attachable: question }
    let(:attachable) { 'question' }
    let(:commentable) { 'question' }
    let(:size) { 1 }
    let(:attributes) { %w(id title body created_at updated_at) }
    let(:path) { 'question' }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}",
                   format: :json,
                   access_token: access_token.token }


      it_behaves_like 'successful request'
      it_behaves_like 'api commentable'
      it_behaves_like 'api attachable'
      it_behaves_like 'api resource with attributes' do

        let(:resource) { question }
      end
    end


    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:post_attributes) {
        {
          question: attributes_for(:question),
          format: :json,
          access_token: access_token.token
        }
      }

      it 'returns 201 status code' do
        post '/api/v1/questions/', post_attributes
        expect(response.status).to eq 201
      end

      it 'saves a question to the db' do
        expect{ post '/api/v1/questions/', post_attributes }.to change(Question, :count).by(1)
      end
    end
  end

  def do_request(options = {})
    post '/api/v1/questions/', { question: attributes_for(:question), format: :json }.merge(options)
  end
end

