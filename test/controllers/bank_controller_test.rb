require "test_helper"

class BankControllerTest < ActionDispatch::IntegrationTest
  test "should get AccountDetails" do
    get bank_AccountDetails_url
    assert_response :success
  end
end
