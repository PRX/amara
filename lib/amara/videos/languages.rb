# -*- encoding: utf-8 -*-

module Amara
  class Videos::Languages < API

    def subtitles(options={}, &block)
      @subtitles ||= Videos::Languages::Subtitles.new(current_options.merge(args_to_options(options)), &block)
    end

  end
end
