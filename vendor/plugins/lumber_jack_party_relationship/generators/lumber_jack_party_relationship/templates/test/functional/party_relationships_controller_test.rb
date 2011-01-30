require 'test_helper'

class PartyPartyRelationshipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:party_relationships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create party_relationship" do
    assert_difference('PartyRelationship.count') do
      post :create, :party_relationship => { }
    end

    assert_redirected_to party_relationship_path(assigns(:party_relationship))
  end

  test "should show party_relationship" do
    get :show, :id => party_relationships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => party_relationships(:one).to_param
    assert_response :success
  end

  test "should update party_relationship" do
    put :update, :id => party_relationships(:one).to_param, :party_relationship => { }
    assert_redirected_to party_relationship_path(assigns(:party_relationship))
  end

  test "should destroy party_relationship" do
    assert_difference('PartyRelationship.count', -1) do
      delete :destroy, :id => party_relationships(:one).to_param
    end

    assert_redirected_to party_relationships_path
  end
end
