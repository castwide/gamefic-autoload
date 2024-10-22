# frozen_string_literal: true

require 'gamefic'
require 'gamefic/autoload/version'
require 'zeitwerk' unless RUBY_ENGINE == 'opal'

module Gamefic
  module Autoload
    def self.setup(directory, namespace: Object)
      if RUBY_ENGINE == 'opal'
        Gamefic.logger.info 'Opal engine detected - Gamefic::Autoload skipped'
      else
        register_and_setup directory, namespace
      end
    end

    def self.registered
      registry.keys
    end

    def self.history(directory)
      registry[directory].eager_load
      histories[directory]
    end

    def self.encode(directory)
      history(directory).map do |hash|
        if File.file?(hash[:file])
          path = hash[:file].sub(/^#{directory}\/?/, '').sub(/\.rb$/, '')
          "require '#{path}'"
        else
          "#{hash[:const].is_a?(Class) ? 'class ' : 'module'} #{hash[:const]}; end"
        end
      end
    end

    def self.encode_all
      registered.flat_map { |directory| encode(directory) }
    end

    class << self
      def register_and_setup(directory, namespace)
        registry[directory] = Zeitwerk::Loader.new.tap do |loader|
          histories[directory] = []
          loader.push_dir directory, namespace: namespace
          loader.on_load do |name, const, file|
            line = { name: name, const: const, file: file }
            histories[directory].push line
          end
          loader.setup
          loader.eager_load
        end
      end

      def registry
        @registry ||= {}
      end

      def histories
        @histories ||= {}
      end
    end
  end
end
