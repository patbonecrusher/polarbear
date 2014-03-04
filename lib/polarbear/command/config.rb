require 'polarbear/utils/executor'

module PolarBear
  module Command

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    class Config

      def initialize
      end

      def load_from_local_settings
        Utils::Executor.instance.execute_command('set')
      end

    end #class Config

  end #module Command
end #module PolarBear