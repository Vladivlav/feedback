class QuestionsController < ApplicationController
  before_action :authenticate_admin!, except: %i(new create)

  def new
    redirect_to questions_path if current_admin

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
      redirect_to question_path(params[:id])
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.admin_id = current_admin.id

    redirect_to edit_question_path(params[:id]) unless @question.answer.blank?

    if @question.update!(question_params)
      QuestionMailer.with(question: @question).send_answer.deliver_later
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
      flash[:notice] = @question.errors.messages[:email].first || @question.errors.messages[:question].first
      render :new, question: @question
    end
  end

  private

  def question_params
    params.require(:question).permit(:question, :email, :answer)
  end
end
