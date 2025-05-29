require "test_helper"

class OnboardingControllerTest < ActionDispatch::IntegrationTest
  test "should get welcome" do
    get onboarding_welcome_url
    assert_response :success
  end

  test "should get interests" do
    get onboarding_interests_url
    assert_response :success
  end

  test "should get save_interests" do
    get onboarding_save_interests_url
    assert_response :success
  end

  test "should get sub_interests" do
    get onboarding_sub_interests_url
    assert_response :success
  end

  test "should get save_sub_interests" do
    get onboarding_save_sub_interests_url
    assert_response :success
  end

  test "should get style" do
    get onboarding_style_url
    assert_response :success
  end

  test "should get personality" do
    get onboarding_personality_url
    assert_response :success
  end

  test "should get friends" do
    get onboarding_friends_url
    assert_response :success
  end

  test "should get complete" do
    get onboarding_complete_url
    assert_response :success
  end
end
