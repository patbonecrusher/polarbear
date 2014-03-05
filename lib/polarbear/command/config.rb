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

        hash = {}
        config_data.each_line { |l|
          updated_line = l.gsub(/\s+/, '').chomp

          regex = /(([^=;]*)=([^=;]*);?)+/
          match = updated_line.match regex
          if !match.nil? && !match[3].empty? && match[3] != '(Empty)'
            hash[match[2]] = match[3]
          end
        }
        hash
      end

    end #class Config

  end #module Command
end #module PolarBear