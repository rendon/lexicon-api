require "test_helper"

class LexemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lexeme = lexemes(:one)
  end

  test "should get index" do
    get lexemes_url, as: :json
    assert_response :success
  end

  test "should create lexeme" do
    assert_difference("Lexeme.count") do
      post lexemes_url, params: { lexeme: { definition: @lexeme.definition, name: @lexeme.name, source: @lexeme.source } }, as: :json
    end

    assert_response :created
  end

  test "should show lexeme" do
    get lexeme_url(@lexeme), as: :json
    assert_response :success
  end

  test "should update lexeme" do
    patch lexeme_url(@lexeme), params: { lexeme: { definition: @lexeme.definition, name: @lexeme.name, source: @lexeme.source } }, as: :json
    assert_response :success
  end

  test "should destroy lexeme" do
    assert_difference("Lexeme.count", -1) do
      delete lexeme_url(@lexeme), as: :json
    end

    assert_response :no_content
  end
end
