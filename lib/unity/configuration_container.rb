# frozen_string_literal: true

require_relative "configuration_container/version"

module Unity
  module ConfigurationContainer
    class Error < StandardError; end

    def self.extended(base)
      base.instance_variable_set(:@unity_configuration_values, {})
      base.instance_variable_set(:@unity_configurations, {})
      base.instance_variable_set(:@unity_configuration_mutex, Mutex.new)
    end

    def configurations_container
      @configurations_container
    end

    def configuration(name, lazy: false, &block)
      @unity_configurations[name] = block
      configuration_for(name) if lazy == false
    end

    def configuration_for(name)
      config = @unity_configuration_values[name]
      return config unless config.nil?

      @unity_configuration_mutex.synchronize do
        @unity_configuration_values[name] ||= @unity_configurations[name].call
      end
    end
  end
end
