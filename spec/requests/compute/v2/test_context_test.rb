require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

describe TestContext do
  describe "#nova_server" do
    before :each do
      @test_subject = TestContext.nova_server do
        Object.new
      end
    end

    it  "should be a singleton " do

      mock = MiniTest::Mock.new
      mock.expect(:new,true)

      result_2 = TestContext.nova_server do
        mock.new
      end

      util_verify_not_called(mock, :new,true)
    end

    it "should allow non block calls" do
      result3 = TestContext.nova_server
      assert_equal(@test_subject, result3)
    end

    it "should allow resetting server" do
      mock = MiniTest::Mock.new
      mock.expect(:new, true)
      TestContext.nova_server(true) do
        mock.new
      end
      mock.verify
    end

    it "should allow resetting context" do
      TestContext.reset_context
      mock = MiniTest::Mock.new
      mock.expect(:new, true)
      TestContext.nova_server do
        mock.new
      end
      mock.verify
    end


  end

  def util_verify_not_called(the_mock, method,return_val)
    exp = "expected #{method.to_s}() => #{return_val.to_s}, got []"
    e = assert_raises MockExpectationError do
      the_mock.verify
    end

    assert_equal exp, e.message
  end
end