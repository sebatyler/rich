require "test_helper"

class CoinoneControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get coinone_index_url
    assert_response :success
  end
end
