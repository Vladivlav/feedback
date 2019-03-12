class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :admin, foreign_key: true
      t.string :question
      t.string :email
      t.text :answer
    end
  end
end
