# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/test_helper')

require 'amara/api'
require 'amara/videos'

require 'webmock/minitest'

describe Amara::Videos do

  it "gets the base path for this subclass of API" do
    videos = Amara::Videos.new
    videos.base_path.must_equal 'videos'
  end

  it "returns a video" do
    response = {
      "all_urls"                    => ["https://archive.org/download/1-test-mp3.JRiaC2.popuparchive.org/test.ogg"],
      "created"                     => "2013-08-29T15:35:25.518514",
      "description"                 => "",
      "duration"                    => nil,
      "id"                          => "s7TbkyDizi6k",
      "languages"                   => [],
      "metadata"                    => {},
      "original_language"           => "en",
      "primary_audio_language_code" => "en",
      "project"                     => nil,
      "resource_uri"                => "/api2/partners/videos/s7TbkyDizi6k/",
      "site_url"                    => "http://staging.amara.org/videos/s7TbkyDizi6k/info/",
      "video"                        => "prx-test-1",
      "thumbnail"                   => "",
      "title"                       => "cmdline-test-1",
      "video_url"                   => "https://archive.org/download/1-test-mp3.JRiaC2.popuparchive.org/test.ogg"
    }.to_json
    stub_request(:get, "https://www.amara.org/api2/partners/videos/s7TbkyDizi6k/").
       to_return(body: response)

    videos = Amara::Videos.new(api_key: 'thisisakey', api_username: 'test_user')

    response = videos.get("s7TbkyDizi6k")
    response.object.wont_be_nil
    video = response.object
    video.id.must_equal 's7TbkyDizi6k'
  end

  it "creates a new video" do
    response = {
      "all_urls"                    => ["https://archive.org/download/1-test-mp3.JRiaC2.popuparchive.org/test.ogg"],
      "created"                     => "2013-08-29T15:35:25.518514",
      "description"                 => "",
      "duration"                    => nil,
      "id"                          => "s7TbkyDizi6k",
      "languages"                   => [],
      "metadata"                    => {},
      "original_language"           => "en",
      "primary_audio_language_code" => "en",
      "project"                     => nil,
      "resource_uri"                => "/api2/partners/videos/s7TbkyDizi6k/",
      "site_url"                    => "http://staging.amara.org/videos/s7TbkyDizi6k/info/",
      "video"                        => "test-team",
      "thumbnail"                   => "",
      "title"                       => "title",
      "video_url"                   => "https://archive.org/download/1-test-mp3.JRiaC2.popuparchive.org/test.ogg"
    }.to_json

    stub_request(:post, "https://www.amara.org/api2/partners/videos/").
      with(:body => "{\"team\":\"test-team\",\"title\":\"title\",\"video_url\":\"https://archive.org/download/1-test-mp3.JRiaC2.popuparchive.org/test.ogg\",\"primary_audio_language_code\":\"en\"}",
           :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'Host'=>'www.amara.org:443', 'User-Agent'=>'Amara Ruby Gem 0.1.0', 'X-Api-Username'=>'test_user', 'X-Apikey'=>'thisisakey'}).
      to_return(:status => 200, :body => response, :headers => {})

    videos = Amara::Videos.new(api_key: 'thisisakey', api_username: 'test_user')
    response = videos.create({
      team:      'test-team',
      title:     'title',
      video_url: 'https://archive.org/download/1-test-mp3.JRiaC2.popuparchive.org/test.ogg',
      primary_audio_language_code: 'en'
    })

    response.object.wont_be_nil
    video = response.object
    video.id.must_equal 's7TbkyDizi6k'
  end

end
