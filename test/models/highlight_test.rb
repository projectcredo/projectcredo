require 'test_helper'

class HighlightTest < ActiveSupport::TestCase
  setup do
    user = Fabricate(:user)
    @paper = Fabricate(:paper, abstract: "This is a long abstract\nhow about them abstracts")
    @highlight = @paper.highlights.new(substring: 'long abstract', user: user)
  end

  test "highlight is invalid if blank" do
    @highlight.substring = "\n"
    assert !@highlight.valid?
  end

  test "highlight is invalid if not substring of paper abstract" do
    @highlight.substring = 'not valid!'
    assert !@highlight.valid?
  end

  test "highlight is invalid if not unique substring" do
    @highlight.substring = 'abstract'
    assert !@highlight.valid?
  end
end
