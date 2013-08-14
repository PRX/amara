# -*- encoding: utf-8 -*-

module Amara
  class Teams < API

    def members(params={}, &block)
      @members ||= ApiFactory.api('Amara::Teams::Members', self, params, &block)
    end

    def projects(params={}, &block)
      @projects ||= ApiFactory.api('Amara::Teams::Projects', self, params, &block)
    end

    def safe_members(params={}, &block)
      @safe_members ||= ApiFactory.api('Amara::Teams::SafeMembers', self, params, &block)
    end

  end
end
