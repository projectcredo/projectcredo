require 'test_helper'

class ArxivTest < ActiveSupport::TestCase
  # testing Arxiv gem integration
  
  test "arxiv id not found error handling" do
    # no errors should be thrown
    test_resource = Arxiv::Resource.new '0000.0000'
    assert !test_resource.response
  end

  test "arxiv id malformed error handling" do
    # no errors should be thrown
    test_resource = Arxiv::Resource.new '1202.08190'
    assert !test_resource.response
  end

end