require 'xml-fu'

module PolarBear
  module Command

    class GlobalOptions

      attr_accessor :show_browser
      attr_accessor :interactive
      attr_accessor :must_be_quiet

      def initialize
        @show_browser = false
        @interactive = false
        @must_be_quiet = true
      end

      def to_hash
        Hash result = {}
        result[:'no-browser'] = '' if !@show_browser
        result[:'non-interactive'] = '' if !@show_browser
        result[:'quiet'] = (@must_be_quiet ?'yes':'no')
        result
      end

    end

    class Batch

      attr_reader :command

      def initialize (options = nil)
        options = GlobalOptions.new if options == nil

        @command = {}
        @command[':batch-commands'] = {}
        @command[':batch-commands'][:'global-options'] = options.to_hash
      end

      def add_command(command_name, hash)
        @command[':batch-commands'][command_name] = hash
      end

      def execute
        Admin.new.execute_batch(XmlFu.xml(@command))
      end
    end

  end
end
