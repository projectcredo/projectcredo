require 'test_helper'

class ArxivTest < ActiveSupport::TestCase
  # testing Arxiv gem integration

  test "arxiv api response no title handling 0000.000 edge case" do
    assert_raises(Arxiv::Error::ManuscriptNotFound) {
      manuscript = Arxiv.get('0000.0000', enable_raw: false)
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