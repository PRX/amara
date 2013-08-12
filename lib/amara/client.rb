# -*- encoding: utf-8 -*-

module Amara
  class Client < API

    def teams(params={}, &block)
      @teams ||= ApiFactory.api('Amara::Teams', self, params, &block)
    end

    # def videos(params={}, &block)
    #   @videos ||= Videos.new(current_options.merge(args_to_options(params)), &block)
    # end

    def languages(params={}, &block)
      @languages ||= ApiFactory.api('Amara::Languages', self, params, &block)
    end

  end
end
