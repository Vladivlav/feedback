class QuestionsController < ApplicationController
  before_action :authenticate_admin!, except: %i(new create)

  def new
    @question = Question.new
  end

  def show
    @question = Question.find(params[:id])
  end

  def index
    @questions = Question.send(params[:type] || 'actual')
  end

  def edit
    @question = Question.find(params[:id])
    if @question.need_an_answer?
      render :edit
    else
      render :show
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.admin_id = current_admin.id
    if @question.update!(question_params)
      redirect_to questions_path
    else
      render :edit
    end
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      redirect_to root_path, notice: "Вопрос успешно отправлен"
    else
      render :new, question: @question
    end
  end

  def question_params
    params.require(:question).permit(:question, :email, :answer)
  end
end
