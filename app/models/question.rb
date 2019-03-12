class Question < ActiveRecord::Base
  scope :actual, -> { where answer: nil }
  scope :archive, -> { where.not answer: nil }

  def source
    self.email.present? ? self.email : 'анонимно'
  end

  def need_an_answer?
    self.answer.blank? && self.email.present?
  end
end