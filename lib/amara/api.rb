# -*- encoding: utf-8 -*-

module Amara
  class API

    include Connection

    attr_reader *Amara::Configuration.keys

    attr_accessor :current_options

    class_eval do
      Amara::Configuration.keys.each do |key|
        define_method "#{key}=" do |arg|
          self.instance_variable_set("@#{key}", arg)
          self.current_options.merge!({:"#{key}" => arg})
        end
      end
    end

    def initialize(options={}, &block)
      apply_options(options)
      yield(self) if block_given?
    end

    def apply_options(options={})
      self.current_options ||= ActiveSupport::HashWithIndifferentAccess.new(Amara.options)
      self.current_options = current_options.merge(args_to_options(options))
      Configuration.keys.each do |key|
        send("#{key}=", current_options[key])
      end
    end

    def update_current_options!(options)
      # any of these which are present in options get dropped
      invalid_options = [:url]

      new_options = args_to_options(options).except(*invalid_options)
      self.current_options = current_options.merge(new_options)
    end

    def request(method, path, params={}) # :nodoc:
      unless (method && [:get, :post, :put, :patch, :delete].include?(method))
        raise ArgumentError, "whoops, that isn't a valid http method: #{method}"
      end

      options = current_options.merge(params[:options] || {})

      # if local :options exist, don't send them to amara.org
      request_params = params.except(:options)
      if params[:data]
        request_params[:data] = params[:data].except(:options)
      end

      conn = connection(options)
      request_path = (conn.path_prefix + '/' + path + '/').gsub(/\/+/, '/')

      response = conn.send(method) do |request|
        case method.to_sym
        when :get, :delete
          request.url(request_path, request_params)
        when :post, :put
          request.path = request_path
          request.body = request_params[:data] ? request_params[:data].to_json : nil
        end
      end

      amara_response = Amara::Response.new(response, { api: self, method: method, path: path, params: params } )
      check_for_error(response) if options[:raise_errors]
      amara_response
    end

    def check_for_error(response)
      status_code_type = response.status.to_s[0]
      case status_code_type
      when "2"
        # puts "all is well, status: #{response.status}"
      when "4"
        if response.status == 404
          raise NotFoundError.new("Resource not found", response)
        else
          raise ClientError.new("Whoops, error back from Amara: #{response.status}", response)
        end
      when "5"
        raise ServerError.new("Whoops, error back from Amara: #{response.status}", response)
      else
        raise UnknownError.new("Unrecongized status code: #{response.status}", response)
      end
    end

    def base_path
      parts = self.class.name.split("::").inject([]){|a, c|
        if c != 'Amara'
          base = c.underscore
          a << base.tr('_','-')
          a << current_options["#{base.singularize}_id"] if current_options["#{base.singularize}_id"]
        end
        a
      }
      parts.join('/')
    end

    def paginate(params={})
      params.reverse_merge(limit: 20, offset: 0)
    end

    def list(params={})
      update_current_options!(params)
      request(:get, base_path, paginate(params))
    end

    def list!(params={})
      list(force_raise_errors(params))
    end

    def get(params={})
      update_current_options!(params)
      request(:get, base_path)
    end

    def get!(params={})
      get(force_raise_errors(params))
    end

    def create(params={})
      update_current_options!(params)
      request(:post, base_path, {data: params})
    end

    def create!(params={})
      create(force_raise_errors(params))
    end

    def update(params={})
      update_current_options!(params)
      request(:put, base_path, {data: params})
    end

    def update!(params={})
      update(force_raise_errors(params))
    end

    def delete(params={})
      update_current_options!(params)
      request(:delete, base_path)
    end

    def delete!(params={})
      delete(force_raise_errors(params))
    end

    def args_to_options(args)
      params =  if args.is_a?(String) || args.is_a?(Symbol)
        {"#{self.class.name.demodulize.downcase.singularize}_id" => args}
      elsif args.is_a?(Hash)
        args
      end
    end

    def force_raise_errors(params)
      (params || {}).with_indifferent_access.tap do |p|
        p[:options] = ActiveSupport::HashWithIndifferentAccess.new(p[:options])
        p[:options][:raise_errors] = true
      end
    end
  end
end
