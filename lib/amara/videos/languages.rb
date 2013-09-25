# -*- encoding: utf-8 -*-

module Amara
  class Videos::Languages < API

    def subtitles(params={}, &block)
      @subtitles ||= ApiFactory.api('Amara::Videos::Languages::Subtitles', self, params, &block)
    end

  end
end
