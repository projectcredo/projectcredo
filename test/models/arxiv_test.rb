require 'test_helper'

class ArxivTest < ActiveSupport::TestCase
  # testing new Arxiv API wrapper
  
  test 'arxiv get response' do
    assert_nothing_raised{
      assert_not_nil Arxiv::Http.query id_list: '1110.4573'
    }
  end

  test 'arxiv id not found handling' do
    # no errors should be thrown
    test_resource = Arxiv::Resource.new '0000.0000'
    assert_nil test_resource.paper_attributes
  end

  test 'arxiv id malformed handling' do
    # no errors should be thrown
    test_resource = Arxiv::Resource.new '1202.08190'
    assert_nil test_resource.paper_attributes
  end

  test 'arxiv query result single entry mapping' do
    # skeleton
    arxiv_resource = Arxiv::Resource.new '1701.00994'
    assert arxiv_resource.paper_attributes.size == 1
  end

  test 'arxiv author mapping' do
    arxiv_resource = Arxiv::Resource.new '1701.00994'
    authors = arxiv_resource.paper_attributes[:authors_attributes]
    assert authors.size == 4
    assert authors[0][:given_name] == 'Vittorio'
    assert authors[0][:family_name] == 'Loreto'
    assert authors[1][:given_name] == 'Vito D. P.'
    assert authors[1][:family_name] == 'Servedio'
    assert authors[2][:given_name] == 'Steven H.'
    assert authors[2][:family_name] == 'Strogatz'
    assert authors[3][:given_name] == 'Francesca'
    assert authors[3][:family_name] == 'Tria'
  end

end