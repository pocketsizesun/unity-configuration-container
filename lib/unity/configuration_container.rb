# frozen_string_literal: true

require_relative "configuration_container/version"

module Unity
  module ConfigurationContainer
    class Error < StandardError; end

    def self.extended(base)
      base.instance_variable_set(:@configurations_container, {})
      base.instance_variable_set(:@configurations_container_mutex, Mutex.new)
    end

    def configurations_container
      @configurations_container
    end

    def configuration_for(type, path)
      config = @configurations_container[path]
      return config unless config.nil?

      @configurations_container_mutex.synchronize do
        @configurations_container[path] ||= \
          case type
          when :yaml, :yml then YAML.load_file(path)
          when :json then JSON.load(File.new(path))
          else
            raise Error, "File type '#{type}' not supported"
          end
      end
    end
  end
end
