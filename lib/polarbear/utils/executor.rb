require 'singleton'

module PolarBear
  module Utils

    class Executor
      include Singleton

      # @param [string] ccollab_exe
      def set_codecollab_exec_path(ccollab_exe)
        @codecollab_execpath = ccollab_exe
      end

      # @param [Array] options
      def set_global_option(options)
        @codecollab_globaloptions = options
      end

      def execute_command(command, input = nil)
        last_command_output = ''

        bearcommand = [@codecollab_execpath, @codecollab_globaloptions, command].join(' ')
        puts bearcommand

        IO.popen(bearcommand, 'r+') { |pipe|

          if input != nil
            pipe.puts(input)
            pipe.close_write
          end

          last_command_output = pipe.read
        }

        raise "#{bearcommand} execution failure" unless ?$ != 0
        last_command_output
      end

    end
  end
end
