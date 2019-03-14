require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @q_without_email = questions(:without_email)
    @q_with_email = questions(:with_email)
    @admin = admins(:admin)
  end

  test "should show one question" do
    get question_url(@q_with_email)
    assert_redirected_to new_admin_session_path

    get question_url(@q_without_email)
    assert_redirected_to new_admin_session_path

    sign_in @admin

    get question_url(@q_with_email)
    assert_response :success

    get question_url(@q_without_email)
    assert_response :success
  end

  test "should get new" do
    get new_question_url
    assert_response :success

    sign_in @admin

    get new_question_url
    assert_redirected_to questions_path
  end

  test "should get index" do
    get questions_path
    assert_redirected_to new_admin_session_path

    sign_in @admin

    get questions_path
    assert_response :success
  end

  test "should get edit" do
    get edit_question_path(@q_with_email)
    assert_redirected_to new_admin_session_path

    get edit_question_path(@q_without_email)
    assert_redirected_to new_admin_session_path

    sign_in @admin

    get edit_question_path(@q_with_email)
    assert_response :success

    get edit_question_path(@q_without_email)
    assert_redirected_to question_path(@q_without_email)

    @q_with_email.answer = "answer"
    @q_with_email.save!

    get edit_question_path(@q_with_email)
    assert_redirected_to question_path(@q_with_email)

    @q_without_email.answer = "answer"
    @q_without_email.save!

    get edit_question_path(@q_without_email)
    assert_redirected_to question_path(@q_without_email)
  end

  test "should update question" do
    patch question_url(@q_with_email), params: { question: { answer: "answer" } }
    assert_redirected_to new_admin_session_path
    assert @q_with_email.reload.answer.blank?

    patch question_url(@q_without_email), params: { question: { answer: "answer" } }
    assert_redirected_to new_admin_session_path
    assert @q_without_email.reload.answer.blank?

    sign_in @admin

    patch question_url(@q_with_email), params: { question: { answer: "answer" } }
    @q_with_email.reload
    assert @q_with_email.answer == "answer"
    assert @q_with_email.admin_id == @admin.id
    assert_redirected_to questions_path
  end

  test "should create question" do
    assert_no_difference('Question.count') do
      post questions_url, params: { question: { question: '', email: '' } }
    end
    assert_template :new
    assert_equal 'Вопрос не может быть пустым', flash[:notice]

    assert_difference('Question.count') do
      post questions_url, params: { question: { question: 'Сколько стоит дом в Эдинбурге?', email: '' } }
    end
    assert_redirected_to root_path
    assert_equal 'Вопрос успешно отправлен', flash[:notice]

    assert_no_difference('Question.count') do
      post questions_url, params: { question: { question: 'А в Швейцарии?', email: 'not_correct_email' } }
    end
    assert_template :new
    assert_equal 'Введите корректный email', flash[:notice]

    assert_no_difference('Question.count') do
      post questions_url, params: { question: { question: '', email: 'it@novik.group' } }
    end
    assert_template :new
    assert_equal 'Вопрос не может быть пустым', flash[:notice]

    assert_difference('Question.count') do
      post questions_url, params: { question: { question: 'Курс доллара за 03.12.94?', email: 'it@novik.group' } }
    end
    assert_redirected_to root_path
    assert_equal 'Вопрос успешно отправлен', flash[:notice]
  end
end