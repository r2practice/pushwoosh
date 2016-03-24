require "pushwoosh/version"
require 'pushwoosh/push_notification'
require 'pushwoosh/configurable'
require 'httparty'
require 'pushwoosh/helpers'
require 'pushwoosh/device_registrations'

module Pushwoosh
  extend Pushwoosh::Configurable

  class << self

    def notify_all(message, notification_options = {})
      PushNotification.new(options).notify_all(message, notification_options)
    end

    def notify_devices(message, devices = [], notification_options = {})
      PushNotification.new(options).notify_devices(message, devices, notification_options)
    end

    def delete_message(message)
      PushNotification.new({auth: Pushwoosh.auth}).delete_message(message)
    end

    def register(data = {})
      DeviceRegistration.new(options).register(data)
    end

    def unregister(hwid = nil)
      DeviceRegistration.new(options).unregister(hwid)
    end
  end
end
