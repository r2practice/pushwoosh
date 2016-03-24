require 'httparty'

module Pushwoosh
  class Request
    include HTTParty

    base_uri 'https://cp.pushwoosh.com/json/1.3/'
    format :json

    def self.make_post!(*args)
      new(*args).make_post!
    end

    def initialize(url, options = {})
      validations!(url, options)

      @options = options
      @notification_options = options.fetch(:notification_options) if options[:notification_options].present?
      @url = url
      @base_request = { request: {} }

      @base_request[:request][:auth] = options[:auth] if options[:auth].present?
      @base_request[:request][:application] = options[:application] if options[:application].present?
      @base_request[:request][:message] = options[:message] if options[:message].present?

      @base_request[:request][:hwid] = options[:hwid] if options[:hwid].present?
      @base_request[:request][:push_token] = options[:push_token] if options[:push_token].present?
      @base_request[:request][:device_type] = options[:device_type] if options[:device_type].present?
    end

    def make_post!
      response = self.class.post(url, body: build_request.to_json).parsed_response
      Response.new(response)
    end

    private

    attr_reader :options, :base_request, :notification_options, :url

    def validations!(url, options)
      if url == '/createMessage'
        fail Pushwoosh::Exceptions::Error, 'Missing application' unless options.fetch(:application)
      end
      fail Pushwoosh::Exceptions::Error, 'Missing auth key' unless options.fetch(:auth)
      fail Pushwoosh::Exceptions::Error, 'URL is empty' if url.nil? || url.empty?
    end

    def build_request
      { request: full_request_with_notifications }
    end

    def full_request_with_notifications
      base_request[:request].merge(notifications: [notification_options])
    end
  end
end