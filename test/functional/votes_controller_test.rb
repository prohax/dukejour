require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:votes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vote" do
    assert_difference('Vote.count') do
      post :create, :vote => { }
    end

    assert_redirected_to vote_path(assigns(:vote))
  end

  test "should show vote" do
    get :show, :id => votes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => votes(:one).to_param
    assert_response :success
  end

  test "should update vote" do
    put :update, :id => votes(:one).to_param, :vote => { }
    assert_redirected_to vote_path(assigns(:vote))
  end

  test "should destroy vote" do
    assert_difference('Vote.count', -1) do
      delete :destroy, :id => votes(:one).to_param
    end

    assert_redirected_to votes_path
  end
end
