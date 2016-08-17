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

    def request(method, path, params: {}, raise_on_error: false) # :nodoc:
      unless (method && [:get, :post, :put, :patch, :delete].include?(method))
        raise ArgumentError, "whoops, that isn't a valid http method: #{method}"
      end

      conn = connection((params[:options] || {}).merge(current_options))
      request_path = (conn.path_prefix + '/' + path + '/').gsub(/\/+/, '/')

      raw_response = conn.send(method) do |request|
        case method.to_sym
        when :get, :delete
          request.url(request_path, params)
        when :post, :put
          request.path = request_path
          request.body = params[:data] ? params[:data].to_json : nil
        end
      end

      response = Amara::Response.new(raw_response, {api: self, method: method, path: path, params: params})
      check_for_error(response) if raise_on_error
      response
    end

    def check_for_error(response)
      status_code = response.status
      status_code_type = status_code.to_s[0]
      case status_code_type
      when "2"
        # puts "all is well, status: #{response.status}"
      when "4", "5"
        raise "Whoops, error back from Amara: #{status_code}"
      else
        raise "Unrecongized status code: #{status_code}"
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
      {limit: 20, offset: 0}.merge(params)
    end

    def list(params={})
      _list(params: params, raise_on_error: false)
    end

    def list!(params={})
      _list(params: params, raise_on_error: true)
    end

    def get(params={})
      _get(params: params, raise_on_error: false)
    end

    def get!(params={})
      _get(params: params, raise_on_error: true)
    end

    def create(params={})
      _create(params: params, raise_on_error: false)
    end

    def create!(params={})
      _create(params: params, raise_on_error: true)
    end

    def update(params={})
      _update(params: params, raise_on_error: false)
    end

    def update!(params={})
      _update(params: params, raise_on_error: true)
    end

    def delete(params={})
      _delete(params: params, raise_on_error: false)
    end

    def delete!(params={})
      _delete(params: params, raise_on_error: true)
    end

    def args_to_options(args)
      params =  if args.is_a?(String) || args.is_a?(Symbol)
        {"#{self.class.name.demodulize.downcase.singularize}_id" => args}
      elsif args.is_a?(Hash)
        args
      end
    end

    private

    def _list(params:, raise_on_error:)
      self.current_options = current_options.merge(args_to_options(params))
      request(:get, base_path, params: paginate(params), raise_on_error: raise_on_error)
    end

    def _get(params:, raise_on_error:)
      self.current_options = current_options.merge(args_to_options(params))
      request(:get, base_path, raise_on_error: raise_on_error)
    end

    def _create(params:, raise_on_error:)
      self.current_options = current_options.merge(args_to_options(params))
      request(:post, base_path, params: {data: params}, raise_on_error: raise_on_error)
    end

    def _update(params:, raise_on_error:)
      self.current_options = current_options.merge(args_to_options(params))
      request(:put, base_path, params: {data: params}, raise_on_error: raise_on_error)
    end

    def _delete(params:, raise_on_error:)
      self.current_options = current_options.merge(args_to_options(params))
      request(:delete, base_path, params: {}, raise_on_error: raise_on_error)
    end
  end
end
