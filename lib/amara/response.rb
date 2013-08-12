# -*- encoding: utf-8 -*-

module Amara
  class Response
    attr_accessor :raw, :request

    def object
      if objects.size == 0
        nil
      elsif objects.size == 1
        objects.first
      elsif objects.size > 1
        objects
      end
    end

    def initialize(response, request={})
      @raw     = response
      @request = request

      check_for_error(response)
    end

    def check_for_error(response)
      status_code_type = response.status.to_s[0]
      case status_code_type
      when "2"
        # puts "all is well, status: #{response.status}"
      when "4", "5"
        raise "Whoops, error back from Amara: #{response.status}"
      else
        raise "Unrecongized status code: #{response.status}"
      end
    end

    def body
      self.raw.body
    end

    def object
      body.objects.nil? ? body : body.objects
    end

    def objects
      Array(self.object)
    end

    def [](key)
      if self.object.is_a?(Array)
        self.object[key]
      else
        self.object.send(:"#{key}")
      end
    end

    def has_key?(key)
      self.object.is_a?(Hash) && self.object.has_key?(key)
    end

    # Coerce any method calls for body attributes
    #
    def method_missing(method_name, *args, &block)
      if self.has_key?(method_name.to_s)
        self.[](method_name, &block)
      elsif self.objects.respond_to?(method_name)
        self.objects.send(method_name, *args, &block)
      elsif self.request[:api].respond_to?(method_name)
        self.request[:api].send(method_name, *args, &block)
      else
        super
      end
    end

    def offset
      return 0 unless self.body.meta
      self.body.meta.offset.to_i
    end

    def total_count
      return 0 unless self.body.meta
      self.body.meta.total_count.to_i
    end

    def limit
      return 0 unless self.body.meta
      self.body.meta.limit.to_i
    end

    def has_next_page?
      (offset + limit) < total_count
    end

    def has_previous_page?
      offset > 0
    end

    def next_page
      return nil unless has_next_page?
      new_offset = [(offset + limit), total_count].min
      new_response = request[:api].request(request[:method], request[:path], request[:params].merge({offset: new_offset, limit: limit}))
      self.raw = new_response.raw
    end

    def previous_page
      return nil unless has_previous_page?
      new_offset = [(offset - limit), 0].max
      new_response = request[:api].request(request[:method], request[:path], request[:params].merge({offset: new_offset, limit: limit}))
      self.raw = new_response.raw
    end

  end
end
