require 'polarbear/utils/executor'

module PolarBear
  module Command

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    class Admin

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      def get_review_xml_info(version)
        execute_admin_command('review-xml', version)
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      def execute_batch(input)
        execute_admin_command('batch - ', '', input)
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      def fetch_report(query)
        execute_admin_command('wget', "\"/go?#{query}\"")
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      def execute_admin_command(command, args, input = nil)
        Utils::Executor.instance.execute_command("--no-browser --quiet admin  #{command} #{args}", input)
      end

    end
  end
end

