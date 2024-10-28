# frozen_string_literal: true

require 'gamefic'
require 'gamefic/autoload/version'
require 'zeitwerk' unless RUBY_ENGINE == 'opal'

module Gamefic
  # A Zeitwerk autoloader for Gamefic.
  #
  # Gamefic::Autoload gives the Gamefic SDK a way to use Zeitwerk's code
  # loading conventions in Opal-based web apps.
  #
  module Autoload
    # Enable autoloading in a directory. See the Zeitwerk documentation for
    # more information.
    #
    # @param directory [String] The directory name
    # @param namespace [Module] The directory's root namespace
    # @yieldparam [Zeitwerk::Loader]
    # @return [Zeitwerk::Loader]
    def self.setup(directory, namespace: Object, &block)
      if RUBY_ENGINE == 'opal'
        Gamefic.logger.info 'Opal engine detected - Gamefic::Autoload skipped'
      else
        register_and_setup directory, namespace, &block
      end
    end

    # A list of all the directories that use autoloading.
    #
    # @return [Array<String>]
    def self.registered
      registry.keys
    end

    # The history of a directory's load events.
    #
    # @return [Array<Hash>]
    def self.history(directory)
      registry[directory].eager_load
      histories[directory]
    end

    # Translate a directory's load history into lines of Ruby source code that
    # can replicate the autoload process without Zeitwerk.
    #
    # @param directory [String]
    # @return [Array<String>]
    def self.encode(directory)
      history(directory).map do |hash|
        if File.file?(hash[:file])
          path = hash[:file].sub(%r{^#{directory}/?}, '').sub(/\.rb$/, '')
          "require '#{path}'"
        else
          "#{hash[:const].is_a?(Class) ? 'class ' : 'module'} #{hash[:const]}; end"
        end
      end
    end

    # Encode all of the registered directories.
    #
    # @return [Array<String>]
    def self.encode_all
      registered.flat_map { |directory| encode(directory) }
    end

    class << self
      private

      def register_and_setup(directory, namespace, &block)
        registry[directory] = Zeitwerk::Loader.new.tap do |loader|
          histories[directory] = []
          loader.push_dir directory, namespace: namespace
          loader.on_load do |name, const, file|
            line = { name: name, const: const, file: file }
            histories[directory].push line
          end
          block&.call(loader)
          loader.setup
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
