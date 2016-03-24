require 'httparty'
require 'json'
require 'pushwoosh/exceptions'
require 'pushwoosh/request'
require 'pushwoosh/response'
require 'pushwoosh/helpers'

module Pushwoosh
  class DeviceRegistration

    def initialize(auth_hash = {})
      @auth_hash = auth_hash
    end

    def register(data = {})
      data = data.slice(:hwid, :device_type, :push_token, :timezone)
      fail Pushwoosh::Exceptions::Error, 'hwid is missing' if data[:hwid].blank?
      fail Pushwoosh::Exceptions::Error, 'device type is missing' if data[:device_type].blank?
      fail Pushwoosh::Exceptions::Error, 'push token is missing' if data[:push_token].blank?
      Request.make_post!('/registerDevice', data.merge(auth_hash))
    end

    def unregister(hwid = nil)
      fail Pushwoosh::Exceptions::Error, 'hwid is missing' if hwid.blank?
      Request.make_post!('/unregisterDevice', {hwid: hwid}.merge(auth_hash))
    end
    private

    attr_reader :auth_hash
  end
end