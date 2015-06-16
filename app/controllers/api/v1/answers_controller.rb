class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]

  def index
    respond_with @answers = @question.answers.all
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create

    respond_with (@answer = @question.answers.create(permitted_params.merge(user: current_resource_owner)))
  end

  private
    def set_question
      @question = Question.find(params[:question_id])
    end

    def permitted_params
      params.require(:answer).permit(:body)
    end
end