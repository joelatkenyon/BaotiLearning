require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get purchase_course" do
    get payments_purchase_course_url
    assert_response :success
  end
end
