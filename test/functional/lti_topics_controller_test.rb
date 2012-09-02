require 'test_helper'

class LtiTopicsControllerTest < ActionController::TestCase
  setup do
    @lti_topic = lti_topics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lti_topics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lti_topic" do
    assert_difference('LtiTopic.count') do
      post :create, lti_topic: { key: @lti_topic.key, name: @lti_topic.name, secret: @lti_topic.secret, topic_id: @lti_topic.topic_id, url: @lti_topic.url, user_id: @lti_topic.user_id, xml_snippet: @lti_topic.xml_snippet }
    end

    assert_redirected_to lti_topic_path(assigns(:lti_topic))
  end

  test "should show lti_topic" do
    get :show, id: @lti_topic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lti_topic
    assert_response :success
  end

  test "should update lti_topic" do
    put :update, id: @lti_topic, lti_topic: { key: @lti_topic.key, name: @lti_topic.name, secret: @lti_topic.secret, topic_id: @lti_topic.topic_id, url: @lti_topic.url, user_id: @lti_topic.user_id, xml_snippet: @lti_topic.xml_snippet }
    assert_redirected_to lti_topic_path(assigns(:lti_topic))
  end

  test "should destroy lti_topic" do
    assert_difference('LtiTopic.count', -1) do
      delete :destroy, id: @lti_topic
    end

    assert_redirected_to lti_topics_path
  end
end
