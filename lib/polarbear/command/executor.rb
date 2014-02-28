module PolarBear
  module Command
    module Executor

      # @param [string] ccollab_exe
      def set_codecollab_exec_path(ccollab_exe)
        @codecollab_execpath = ccollab_exe
      end

      # @param [Array] options
      def set_global_option(options)
        @codecollab_globaloptions = options
      end

      # @param [Array] command
      # @return [Bool]
      def execute_command(command)
        bearcommand = [@codecollab_execpath, @codecollab_globaloptions, command].join(' ')
        puts bearcommand
        `#{bearcommand} 2>&1`
      end

    end
  end
end
