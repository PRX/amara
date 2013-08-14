# -*- encoding: utf-8 -*-

module Amara
  class Videos < API

    VIDEO_ATTRIBUTES    = [:all_urls, :created, :description, :duration, :id, :languages, :original_language, :project, :resource_uri, :site_url, :team, :thumbnail, :title]
    VIDEO_CREATE_PARAMS = [:duration, :primary_audio_language_code, :title, :video_url]
    VIDEO_LIST_PARAMS   = [:order_by, :project, :team, :video_url]
    VIDEO_ORDERING      = [:created, :title]

    def languages(options={}, &block)
      @languages ||= ApiFactory.api('Amara::Videos::Languages', self, params, &block)
    end

    def urls(options={}, &block)
      @urls ||= ApiFactory.api('Amara::Videos::Urls', self, params, &block)
    end

  end
end
