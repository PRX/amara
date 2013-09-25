# -*- encoding: utf-8 -*-

module Amara
  class Teams < API

    def applications(params={}, &block)
      @applications ||= ApiFactory.api('Amara::Teams::Applications', self, params, &block)
    end

    def members(params={}, &block)
      @members ||= ApiFactory.api('Amara::Teams::Members', self, params, &block)
    end

    def projects(params={}, &block)
      @projects ||= ApiFactory.api('Amara::Teams::Projects', self, params, &block)
    end

    def safe_members(params={}, &block)
      @safe_members ||= ApiFactory.api('Amara::Teams::SafeMembers', self, params, &block)
    end

    def tasks(params={}, &block)
      @tasks ||= ApiFactory.api('Amara::Teams::Tasks', self, params, &block)
    end

  end
end
