# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

require 'amara/api'
require 'amara/teams'
require 'amara/teams/tasks'

require 'webmock/minitest'

describe Amara::Teams::Tasks do

  it "gets the base path for this subclass of API" do
    teams = Amara::Teams::Tasks.new(team_id: 'test-team')
    teams.base_path.must_equal 'teams/test-team/tasks'

    teams = Amara::Teams::Tasks.new(team_id: 'test-team', task_id: 'test-task')
    teams.base_path.must_equal 'teams/test-team/tasks/test-task'
  end

  it "gets a list of tasks for a team" do

    first_response = '{"meta": {"limit": 2, "next": "/api2/partners/teams/test-team/tasks/?limit=2&offset=2", "offset": 0, "previous": null, "total_count": 5}, "objects": [{"created": "2013-02-14T07:29:55"}, {"created": "2011-03-01T11:38:16"}]}'

    stub_request(:get, "https://www.amara.org/api2/partners/teams/test-team/tasks/?limit=2&offset=0").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'Host'=>'www.amara.org:443'}).
      to_return(:status => 200, :body => first_response, :headers => {})

    amara = Amara::Client.new
    response = amara.teams('test-team').tasks.list(limit: 2)

    response.must_be_instance_of Amara::Response
    response.objects.must_be_instance_of Hashie::Array
    response.objects.each_with_index do |obj, i|
      obj.must_equal Hashie::Mash.new(JSON.parse(first_response)['objects'][i])
    end
  end

end
