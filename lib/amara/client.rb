# -*- encoding: utf-8 -*-

module Amara
  class Client < API

    def activity(params={}, &block)
      @activity ||= ApiFactory.api('Amara::Activity', self, params, &block)
    end

    def languages(params={}, &block)
      @languages ||= ApiFactory.api('Amara::Languages', self, params, &block)
    end

    def message(params={}, &block)
      @message ||= ApiFactory.api('Amara::Message', self, params, &block)
    end

    def teams(params={}, &block)
      @teams ||= ApiFactory.api('Amara::Teams', self, params, &block)
    end

    def videos(params={}, &block)
      @videos ||= ApiFactory.api('Amara::Videos', self, params, &block)
    end

    def users(params={}, &block)
      @users ||= ApiFactory.api('Amara::Users', self, params, &block)
    end

  end
end
