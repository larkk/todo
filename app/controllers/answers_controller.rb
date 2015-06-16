class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :set_the_best]
  before_action :set_question, only: [ :create, :update, :destroy, :set_the_best]
  before_action :authorize_user, only: [:update, :destroy]
  after_action :publish_to_answers, only: :create
  include Voted
  authorize_resource

  respond_to :js, except: :create
  respond_to :json, only: [:create, :update]

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer, template: 'answers/submit')
  end

  def destroy
    @answer.destroy!
  end

  def set_the_best
    @answer.set_the_best if @question.user == current_user
  end

  private
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_question
      @question = params.has_key?(:question_id) ? Question.find(params[:question_id]) : @answer.question
    end

    def authorize_user
      redirect_to root_path unless @answer.user == current_user
    end

    def publish_to_answers
      PrivatePub.publish_to channel, answer: render_to_string(template: 'answers/submit') if @answer.valid?
    end

    def channel
      "/questions/#{@question.id}/answers"
    end
end
