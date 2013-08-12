# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/test_helper')

require 'amara/api'
require 'amara/teams'

require 'webmock/minitest'

describe Amara::Client do

  it "gets the base path for this subclass of API" do
    teams = Amara::Teams.new
    teams.base_path.must_equal 'teams'
  end

  it "returns a list of teams" do
    first_response = '{"meta": {"limit": 2, "next": "/api2/partners/team/?limit=2&offset=2", "offset": 0, "previous": null, "total_count": 5}, "objects": [{"created": "2013-02-14T07:29:55", "deleted": false, "description": "", "header_html_text": "", "is_moderated": false, "is_visible": true, "logo": null, "max_tasks_per_member": null, "membership_policy": "Open", "name": "", "projects_enabled": false, "resource_uri": "/api2/partners/teams/tedx-import/", "slug": "tedx-import", "subtitle_policy": "Anyone", "task_assign_policy": "Any team member", "task_expiration": null, "translate_policy": "Anyone", "video_policy": "Any team member", "workflow_enabled": false}, {"created": "2011-03-01T11:38:16", "deleted": false, "description": "", "header_html_text": "<style>\r\n#custom_header {\r\nbackground: transparent url(http://blog.universalsubtitles.org/wp-content/uploads/2011/03/aljazeera_header_bg.png) 0 0 no-repeat;\r\nwidth: 943px;\r\nheight: 237px;\r\nposition: relative;\r\n}\r\n\r\n.team-detail {\r\ndisplay: none;\r\n}\r\n\r\n#team_video_policy {\r\ndisplay: none;\r\n}\r\n\r\n#team_detail_managers {\r\ndisplay: none;\r\n}\r\n\r\n#team_member_policy {\r\ndisplay: none;\r\n}\r\n\r\n#team_volunteer_detail {\r\ndisplay: block;\r\n}\r\n\r\n#custom_header {\r\nmargin-bottom: 15px;\r\n}\r\n\r\n#team_title {\r\ndisplay: none;\r\n}\r\n\r\n#custom_header a#logo_link {\r\nwidth: 450px;\r\nheight: 91px;\r\ndisplay: block;\r\nposition: absolute;\r\ntop: 88px;\r\nleft: 95px;\r\ntext-indent: -99999px;\r\n}\r\n\r\n#custom_header #sidecol {\r\nwidth: 290px;\r\nheight: 200px;\r\nfloat: right;\r\nmargin: 30px 12px 0 0;\r\n}\r\n\r\n#custom_header #sidecol h1 {\r\nfont-size: 18px;\r\nfont-weight: bold;\r\ntext-shadow: 0 -1px 0 #f97f00;\r\ncolor: #FFF;\r\nmargin: 0 0 15px 0;\r\n}\r\n#custom_header #sidecol p {\r\nfont-size: 15px;\r\nline-height: 25px;\r\ntext-shadow: 0 -1px 0 #f97f00;\r\ncolor: #FFF;\r\nwidth: 280px;\r\n}\r\n</style>\r\n<div id=\"custom_header\">\r\n<a id=\"logo_link\" href=\"http://english.aljazeera.net\">Al Jazeera</a>\r\n<div id=\"sidecol\">\r\n<h1>Join the Translation Team</h1>\r\n<p>These are some of the popular Al Jazeera videos in English and Arabic, as well as other videos that complement Al Jazeera\'s news output from around the globe.</p>\r\n</div><!-- // sidecol -->\r\n</div><!-- // custom_header -->", "is_moderated": false, "is_visible": true, "logo": "http://s3.amazonaws.com/s3.userdata.staging.amara.org/teams/logo/6f94ad51700869bc359bbb750f1420e0a05493f1.png", "max_tasks_per_member": null, "membership_policy": "Open", "name": "Al Jazeera", "projects_enabled": false, "resource_uri": "/api2/partners/teams/al-jazeera/", "slug": "al-jazeera", "subtitle_policy": "Anyone", "task_assign_policy": "Any team member", "task_expiration": null, "translate_policy": "Anyone", "video_policy": "Admins only", "workflow_enabled": false}]}'
    stub_request(:get, 'https://www.amara.org/api2/partners/teams/?limit=2&offset=0').
       to_return(body: first_response)

    teams = Amara::Teams.new(api_key: 'thisisakey', api_username: 'test_user')
    # puts teams.list.raw.inspect

    response = teams.list(limit: 2)
    response.objects.must_equal response.object

    response.offset.must_equal 0
    response.limit.must_equal 2
    response.size.must_equal 2
    response.first.slug.must_equal "tedx-import"
  end

  it "returns a team" do
    response = '{"created": "2013-02-14T07:29:55", "deleted": false, "description": "", "header_html_text": "", "is_moderated": false, "is_visible": true, "logo": null, "max_tasks_per_member": null, "membership_policy": "Open", "name": "", "projects_enabled": false, "resource_uri": "/api2/partners/teams/tedx-import/", "slug": "tedx-import", "subtitle_policy": "Anyone", "task_assign_policy": "Any team member", "task_expiration": null, "translate_policy": "Anyone", "video_policy": "Any team member", "workflow_enabled": false}'
    stub_request(:get, "https://www.amara.org/api2/partners/teams/tedx-import/").
       to_return(body: response)

    teams = Amara::Teams.new(api_key: 'thisisakey', api_username: 'test_user')
    # puts teams.list.raw.inspect

    response = teams.get("tedx-import")
    response.object.wont_be_nil
    team = response.object
    team.slug.must_equal 'tedx-import'

    response = teams.get(team_id: "tedx-import")
    response.object.wont_be_nil
    team = response.object
    team.slug.must_equal 'tedx-import'
  end

  it "created a new team" do
    create_response = '{"created": "2013-08-01T13:11:45.167206", "deleted": false, "description": "", "header_html_text": "", "is_moderated": false, "is_visible": true, "logo": null, "max_tasks_per_member": null, "membership_policy": "Open", "name": "prx test 1", "projects_enabled": false, "resource_uri": "/api2/partners/teams/prx-test-1/", "slug": "prx-test-1", "subtitle_policy": "Anyone", "task_assign_policy": "Any team member", "task_expiration": null, "translate_policy": "Anyone", "video_policy": "Any team member", "workflow_enabled": false}'
  end

end
