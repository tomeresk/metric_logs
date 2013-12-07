require 'test_helper'

class MetricsControllerTest < ActionController::TestCase
  test "should get map_display" do
    get :map_display
    assert_response :success
  end

end
