require 'bundler/setup'
require 'unity-configuration-container'

module Foo
  extend Unity::ConfigurationContainer

  configuration :test, lazy: false do
     { x: '1' }
  end
end

pp Foo.configuration_for(:test)
