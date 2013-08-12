# -*- encoding: utf-8 -*-

module Amara
  class Teams < API

    def members(options={}, &block)
      @members ||= Teams::Members.new(current_options.merge(args_to_options(options)), &block)
    end

    def projects(options={}, &block)
      @projects ||= Teams::Projects.new(current_options.merge(args_to_options(options)), &block)
    end

  end
end
