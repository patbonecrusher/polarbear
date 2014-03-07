require 'polarbear/utils/executor'

module PolarBear
  module Command

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    class AdminReview

      # Delete an existing Review
      def delete(id)
        execute_admin_review_command('delete', id)
      end

      # Cancel an in-progress Review
      def cancel(id)
        execute_admin_review_command('cancel', id)
      end

      # Reject an in-progress Review
      def reject(id)
        execute_admin_review_command('reject', id)
      end

      # Finish current phase of a Review
      def finish(id)
        execute_admin_review_command('finish', id)
      end

      def execute_admin_review_command(command, args)
        Utils::Executor.instance.execute_command("--no-browser --quiet admin review #{command} #{args}")
      end

    end # class Admin Review

  end # module Command
end # module PolarBear
