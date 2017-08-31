require 'test_helper'

class NumbersRDFTest < ActiveSupport::TestCase
  should "respond to a basic GET request at the root" do
    response = NumbersRDF::NumbersHelper::path_to_numbers_server_response('/')

    assert_equal '200', response.code
  end

  should "raise the appropriate timeout error" do
    # This test is unreliable, and should be replaced with e.g. Mocha on Net:HTTP to raise ::Timeout::Error
    # assert_raise NumbersRDF::Timeout do
    #   Timeout::timeout(0.1) do
    #     response = NumbersRDF::NumbersHelper::path_to_numbers_server_response('/')
    #   end
    # end
  end

  should "give the correct identifier hash for identifier strings" do
    assert_equal({"ddbdp" => ["papyri.info/ddbdp/bgu;1;1"]}, NumbersRDF::NumbersHelper.identifiers_to_hash(['papyri.info/ddbdp/bgu;1;1']))
    assert_equal({"hgv" => ["papyri.info/hgv/1"]}, NumbersRDF::NumbersHelper.identifiers_to_hash(['papyri.info/hgv/1']))
    assert_equal({"dclp" => ["papyri.info/dclp/1"]}, NumbersRDF::NumbersHelper.identifiers_to_hash(['papyri.info/dclp/1']))
  end
end
