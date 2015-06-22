# -*- encoding: utf-8 -*-

require 'faraday_middleware'

module Amara
  module Connection

    ALLOWED_OPTIONS = [
      :headers,
      :url,
      :params,
      :request,
      :ssl
    ].freeze

    def merge_default_options(opts={})
      headers = opts.delete(:headers) || {}
      options = HashWithIndifferentAccess.new(
        {
          :headers => {
            'User-Agent'   => user_agent,
            'Accept'       => "application/json",
            'Content-Type' => "application/json"
          },
          :ssl => {:verify => false},
          :url => endpoint
        }        
      ).merge(opts)
      options[:headers] = options[:headers].merge(headers)
      Amara::HEADERS.each{|k,v| options[:headers][v] = options.delete(k) if options.key?(k)}
      options.slice(*ALLOWED_OPTIONS)      
    end

    def connection(options={})
      opts = merge_default_options(options)
      Faraday.new(opts) do |connection|
        connection.request  :url_encoded

        connection.response :mashify
        connection.response :logger if ENV['DEBUG']
        connection.response :json

        connection.adapter(adapter)
      end
    end
  end
end
