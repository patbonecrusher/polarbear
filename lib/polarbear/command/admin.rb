require 'polarbear/utils/executor'
require 'gyoku'

module PolarBear
  module Command

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    class Admin

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      def initialize
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [Object] version
      def get_review_xml_info(version)
        execute_command("admin review-xml #{version}")
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [int] reviewid
      def cancel_review(reviewid)
        execute_admin_command('cancel', "#{reviewid}")
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [int] reviewid
      def delete_review(reviewid)
        execute_admin_command('delete', "#{reviewid}")
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [int] reviewid
      def move_to_next_phase(reviewid)
        execute_admin_command('finish', "#{reviewid}")
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      def finish_review(reviewid)
        execute_admin_command('finish', "#{reviewid}")
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      #def add_participants(reviewers, observers)
      #end

      # @param [Object] command
      # @param [Object] args
      # @return [Object]
      def execute_admin_command(command, args)
        execute_command("--no-browser --quiet admin review #{command} #{args}")
      end

    end
  end
end

