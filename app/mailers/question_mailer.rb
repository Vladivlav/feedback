class QuestionMailer < ApplicationMailer
  default from: 'no-reply@feedback.com'

  def send_answer
    @question = params[:question]
    mail(to: @question.email, subject: 'Ответ на ваш вопрос')
  end
end
