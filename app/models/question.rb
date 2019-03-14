class Question < ActiveRecord::Base
  scope :actual, -> { where answer: nil }
  scope :archive, -> { where.not answer: nil }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP , message: 'Введите корректный email' }, allow_blank: true, on: :create
  validates :question, presence: true

  def source
    self.email.present? ? self.email : 'анонимно'
  end

  def need_an_answer?
    self.answer.blank? && self.email.present?
  end
end