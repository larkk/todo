class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :set_questions, only: [:index, :update, :destroy]
  before_action :set_subscription, only: :show
  after_action :publish, only: :create

  include Voted

  authorize_resource

  respond_to :html, :js
  respond_to :json, only: :create

  def index
    respond_with @questions
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with @question
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    respond_with @question
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    flash.now[:notice] = 'Question has been successfully deleted!'
    respond_with(@question.destroy)
  end

  private
    def set_questions
      @questions = Question.all
    end

    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end

    def set_subscription
      @subscription = @question.subscriptions.find_by(user: current_user) || Subscription.new
    end

    def publish
      PrivatePub.publish_to '/questions', question: render_to_string(template: 'questions/submit.json.jbuilder') if @question.valid?
    end
end
