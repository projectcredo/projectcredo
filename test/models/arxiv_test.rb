require 'test_helper'

class ArxivTest < ActiveSupport::TestCase
  # testing new Arxiv API wrapper
  
  test "arxiv get response" do
    assert_nothing_raised{
      assert_not_nil Arxiv::Http.query '1110.4573'
    }
  end

  test "arxiv id not found error handling" do
    # no errors should be thrown
    assert_nothing_raised {
      test_resource = Arxiv::Resource.new '0000.0000'
    }
    assert !test_resource.response
  end

  test "arxiv id malformed error handling" do
    # no errors should be thrown
    assert_nothing_raised {
      test_resource = Arxiv::Resource.new '1202.08190'
    }
    assert !test_resource.response
  end

end