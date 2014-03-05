require 'polarbear/utils/executor'

module PolarBear
  module Command

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    class Config

      def initialize
      end

      def load_from_local_settings
        config_data = Utils::Executor.instance.execute_command('set')

        keyValues = []
        config_data.each_line { |l|
          if l.include? '='
            keyValues.push(l.gsub(/\s+/, '').chomp)
          end
        }

        Hash[keyValues.each.map { |kv| kv.chomp.split('=', 2) }]

      end

    end #class Config

  end #module Command
end #module PolarBear