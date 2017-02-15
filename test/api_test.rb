# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/test_helper')

# create dummy class based on the API
class TestApi < ::Amara::API
end

describe Amara::API do

  before {
    @amara_api_username = ENV['AMARA_API_USERNAME'] || "testuser"
    @amara_api_key      = ENV['AMARA_API_KEY']      || "thisisatestkeyonly"
  }

  it "is initialized with defaults" do
    oc = TestApi.new
    oc.current_options.wont_be_nil
    oc.current_options.must_equal HashWithIndifferentAccess.new(Amara.options)
  end

  it "is initialized with specific values" do
    oc = TestApi.new(api_key: @amara_api_key, api_username: @amara_api_username)
    oc.current_options.wont_be_nil
    oc.current_options.wont_equal Amara.options

    oc.current_options[:api_key].must_equal @amara_api_key
    oc.api_key.must_equal @amara_api_key

    oc.current_options[:api_username].must_equal @amara_api_username
    oc.api_username.must_equal @amara_api_username
  end

  it "returns a list and paginates through it" do
    first_response = '{"meta": {"limit": 2, "next": "/api2/partners/api/?limit=2&offset=2", "offset": 0, "previous": null, "total_count": 5}, "objects": [{"id": 1}, {"id": 2}]}'
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(body: first_response)

    api = Amara::API.new(api_key: 'thisisakey', api_username: 'test_user')
    # puts teams.list.raw.inspect

    response = api.list(limit: 2)
    response.objects.must_equal response.object

    response.offset.must_equal 0
    response.limit.must_equal 2
    response.size.must_equal 2
    response.first.id.must_equal 1

    second_response = '{"meta": {"limit": 2, "next": "/api2/partners/api/?limit=2&offset=4", "offset": 2, "previous":"/api2/partners/api/?limit=2&offset=0", "total_count": 5}, "objects": [{"id": 3}, {"id": 4}]}'
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=2').
       to_return(body: second_response)

    response.must_be :has_next_page?
    response.next_page
    response.offset.must_equal 2
    response.limit.must_equal 2
    response.first.id.must_equal 3

    third_response = '{"meta": {"limit": 2, "next": null, "offset": 4, "previous":"/api2/partners/api/?limit=2&offset=2", "total_count": 5}, "objects": [{"id": 5}]}'
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=4').
       to_return(body: third_response)

    response.must_be :has_next_page?
    response.next_page
    response.offset.must_equal 4
    response.limit.must_equal 2
    response.first.id.must_equal 5

    response.wont_be :has_next_page?
  end

  it "will raise errors" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(status: 500, body: '{}')

    api = Amara::API.new(raise_errors: true)

    error = proc {
      response = api.list(limit: 2)
    }.must_raise Amara::ServerError

    error.response.wont_be_nil
    error.response.status.must_equal 500
    error.message.must_equal 'Whoops, error back from Amara: 500'
  end

  it "can return errors instead of raise them" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(status: 500, body: '{}')

    api = Amara::API.new(raise_errors: false)
    response = api.list(limit: 2)
    response.status.must_equal 500

    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(status: 500, body: '{}')

    api = Amara::API.new(raise_errors: true)
    response = api.list(limit: 2, options: { raise_errors: false } )
    response.status.must_equal 500
  end

  it "can use bang methods to raise errors" do
    stub_request(:get, 'https://www.amara.org/api2/partners/api/?limit=2&offset=0').
       to_return(status: 500, body: '{}')

    api = Amara::API.new(raise_errors: false)

    error = proc {
      response = api.list!(limit: 2)
    }.must_raise Amara::ServerError

    error.response.wont_be_nil
    error.response.status.must_equal 500
    error.message.must_equal 'Whoops, error back from Amara: 500'
  end

  it "should not post local options to amara" do
    expected_body = {a: 1, b: 2}

    stub_post = stub_request(:post, 'https://www.amara.org/api2/partners/api/').
      with(body: expected_body.to_json)

    api = Amara::API.new
    api.create!(a:1, b:2)

    assert_requested stub_post
  end
end
