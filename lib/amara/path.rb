# -*- encoding: utf-8 -*-

module Amara
  class Path < API
    def base_path
      path = self.current_options[:path]
      if path.kind_of? Array
        path.join('/')
      else
        path
      end
    end
  end
end
