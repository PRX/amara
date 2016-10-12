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

    def request(method, path, params={}) # :nodoc:
      unless (method && [:get, :post, :put, :patch, :delete].include?(method))
        raise ArgumentError, "whoops, that isn't a valid http method: #{method}"
      end

      conn = connection((params[:options] || {}).merge(current_options))
      request_path = (conn.path_prefix + '/' + path + '/').gsub(/\/+/, '/')

      response = conn.send(method) do |request|
        case method.to_sym
        when :get, :delete
          request.url(request_path, params)
        when :post, :put
          request.path = request_path
          request.body = params[:data] ? params[:data].to_json : nil
        end
      end
      response = Amara::Response.new(response, { api: self, method: method, path: path, params: params } )
      check_for_error(response) if !current_options[:return_errors]
      response
    end

    def check_for_error(response)
      status_code_type = response.status.to_s[0]
      case status_code_type
      when "2"
        # puts "all is well, status: #{response.status}"
      when "4"
        if response.status == 404
          raise NotFoundError
        else
          raise ClientError, "Whoops, error back from Amara: #{response.status}"
        end
      when "5"
        raise ServerError, "Whoops, error back from Amara: #{response.status}"
      else
        raise UnknownError, "Unrecongized status code: #{response.status}"
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
      self.current_options = current_options.merge(args_to_options(params))
      request(:get, base_path, paginate(params))
    end

    def get(params={})
      self.current_options = current_options.merge(args_to_options(params))
      request(:get, base_path)
    end

    def create(params={})
      self.current_options = current_options.merge(args_to_options(params))
      request(:post, base_path, {data: params})
    end

    def update(params={})
      self.current_options = current_options.merge(args_to_options(params))
      request(:put, base_path, {data: params})
    end

    def delete(params={})
      self.current_options = current_options.merge(args_to_options(params))
      request(:delete, base_path)
    end

    def args_to_options(args)
      params =  if args.is_a?(String) || args.is_a?(Symbol)
        {"#{self.class.name.demodulize.downcase.singularize}_id" => args}
      elsif args.is_a?(Hash)
        args
      end
    end
  end
end
