require 'test_helper'

class LibrariesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:libraries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create library" do
    assert_difference('Library.count') do
      post :create, :library => { }
    end

    assert_redirected_to library_path(assigns(:library))
  end

  test "should show library" do
    get :show, :id => libraries(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => libraries(:one).to_param
    assert_response :success
  end

  test "should update library" do
    put :update, :id => libraries(:one).to_param, :library => { }
    assert_redirected_to library_path(assigns(:library))
  end

  test "should destroy library" do
    assert_difference('Library.count', -1) do
      delete :destroy, :id => libraries(:one).to_param
    end

    assert_redirected_to libraries_path
  end
end
