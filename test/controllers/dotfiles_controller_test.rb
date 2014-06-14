require 'test_helper'

class DotfilesControllerTest < ActionController::TestCase
  setup do
    @dotfile = dotfiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dotfiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dotfile" do
    assert_difference('Dotfile.count') do
      post :create, dotfile: { body: @dotfile.body, title: @dotfile.title }
    end

    assert_redirected_to dotfile_path(assigns(:dotfile))
  end

  test "should show dotfile" do
    get :show, id: @dotfile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dotfile
    assert_response :success
  end

  test "should update dotfile" do
    patch :update, id: @dotfile, dotfile: { body: @dotfile.body, title: @dotfile.title }
    assert_redirected_to dotfile_path(assigns(:dotfile))
  end

  test "should destroy dotfile" do
    assert_difference('Dotfile.count', -1) do
      delete :destroy, id: @dotfile
    end

    assert_redirected_to dotfiles_path
  end
end
