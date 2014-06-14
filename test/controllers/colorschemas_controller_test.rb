require 'test_helper'

class ColorschemasControllerTest < ActionController::TestCase
  setup do
    @colorschema = colorschemas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:colorschemas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create colorschema" do
    assert_difference('Colorschema.count') do
      post :create, colorschema: { body: @colorschema.body, title: @colorschema.title }
    end

    assert_redirected_to colorschema_path(assigns(:colorschema))
  end

  test "should show colorschema" do
    get :show, id: @colorschema
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @colorschema
    assert_response :success
  end

  test "should update colorschema" do
    patch :update, id: @colorschema, colorschema: { body: @colorschema.body, title: @colorschema.title }
    assert_redirected_to colorschema_path(assigns(:colorschema))
  end

  test "should destroy colorschema" do
    assert_difference('Colorschema.count', -1) do
      delete :destroy, id: @colorschema
    end

    assert_redirected_to colorschemas_path
  end
end
