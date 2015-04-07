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
      options
    end

    def connection(options={})
      opts = merge_default_options(options)
      legal_opts = ['url', 'params', 'headers', 'request', 'ssl', 'proxy']
      ok_opts = {}
      legal_opts.each do |o|
        if opts.has_key? o
          ok_opts[o] = opts[o]
        end
      end
      #STDERR.puts "connection:\n\toptions: #{options.inspect}\n\topts: #{opts.inspect}\n\tok_opts: #{ok_opts.inspect}"
      Faraday.new(ok_opts) do |faraday|
        faraday.request  :url_encoded

        faraday.response :mashify
        faraday.response :logger if ENV['DEBUG']
        faraday.response :json

        faraday.adapter(adapter)  # IMPORTANT to be last
      end

    end
  end
end
