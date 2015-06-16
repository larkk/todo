require 'rails_helper'

describe QuestionsController do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question, user: user }
  let(:another_question) { create :question, user: another_user }

  let(:resource) { question }
  let(:another_resource) { another_question }
  let(:params) {{ id: resource, format: :json }}
  let(:another_params) {{ id: another_resource,
                          format: :json}}

  it_behaves_like 'votable'

  describe 'GET #index' do
    let(:questions) { create_list :question, 2 }
    before { get :index }

    it 'assigns the list of all questions to @questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    before{ sign_in(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:channel) { '/questions' }
    let(:params) {{ question: attributes_for(:question) }}

    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { do_request }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        do_request
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it_behaves_like 'publishable'
    end

    context 'with invalid attributes' do
      let(:params) {{ question: attributes_for(:question, :with_wrong_attributes) }}
      it 'does not save question to the database' do
        expect { do_request }.to_not change(user.questions, :count)
      end

      it 'renders new view' do
        do_request
        expect(response).to render_template :new
      end

      it_behaves_like 'not publishable'
    end

    def do_request
      post :create, params
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }
    let!(:authors_question) { create :question, user: user }
    let!(:another_user) { create :user, :with_questions }
    let(:update_params) {{ id: question,
                           question: attributes_for(:question),
                           user_id: user,
                           format: :js }}

    it 'assigns question to @question' do
      patch :update, update_params
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, update_params.update(question: { title: 'new title', body: 'new body'})
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it 'does not change another users question' do
      question = another_user.questions.first
      patch :update, id: question,
                     question: { title: 'new title', body: 'new body'},
                     user_id: another_user,
                     format: :js
      question.reload
      expect(question.title).not_to eq 'new title'
      expect(question.body).not_to eq 'new body'
    end

    it 'renders update template' do
      patch :update, update_params
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }
    let!(:authors_question) { create :question, user: user }
    let!(:another_user) { create :user, :with_questions }

    context 'author' do
      it 'deletes authors question from the database' do
        expect { delete :destroy, id: authors_question, format: :js }
            .to change(user.questions, :count).by(-1)
      end

      it 'assigns questions to @questions' do
        delete :destroy, id: authors_question, format: :js
        expect(assigns(:questions)).to eq Question.all
      end

      it 'renders index view' do
        delete :destroy, id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'another user' do
      it "does not delete another user's question" do
        expect { delete :destroy, id: another_user.questions.first, format: :js }
            .to_not change(another_user.questions, :count)
      end

      it 'renders show view' do
        delete :destroy, id: another_user.questions.first, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end


end
