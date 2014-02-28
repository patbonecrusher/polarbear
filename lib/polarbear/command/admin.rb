require 'polarbear/command/executor'

module PolarBear
  module Command

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    class Admin
      include Executor

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [string] ccollab_exe
      def initialize(ccollab_exe)
        set_codecollab_exec_path(ccollab_exe)
        set_global_option('--no-browser')
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [string] title
      # @return [int]
      def create_review(title)
        execute_admin_command('create', "--title '#{title}'")
        raise 'failure running command' if $?.exitstatus != 0

        reviewid=execute_command("admin review-xml last --xpath \"string(//reviews/review/@reviewId)\"")
        raise 'failure running command' if $?.exitstatus != 0
        reviewid
      end

      # @param [Object] version
      def get_review_xml_info(version)
        execute_command("admin review-xml #{version}")
      end

      def get_open_reviews_id
        reviews = execute_command('admin wget "/go?page=ReportReviewList&formSubmittedreportConfig=1&reviewIdVis=y&reviewTitleVis=y&data-format=csv&phaseFilter=inprogress"')

        result = Array.new
        string_io = StringIO.new(reviews)
        string_io.each_line() {|line| result.push line.match( /^[a-zA-Z0-9]*/ )}
        result
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [int] reviewid
      def cancel_review(reviewid)
        execute_admin_command('cancel', "#{reviewid}")
        raise 'failure running command' if $?.exitstatus != 0
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [int] reviewid
      def delete_review(reviewid)
        execute_admin_command('delete', "#{reviewid}")
        raise 'failure running command' if $?.exitstatus != 0
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      # @param [int] reviewid
      def move_to_next_phase(reviewid)
        execute_admin_command('finish', "#{reviewid}")
        raise 'failure running command' if $?.exitstatus != 0
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      def finish_review(reviewid)
        execute_admin_command('finish', "#{reviewid}")
        raise 'failure running command' if $?.exitstatus != 0
      end

      # ------------------------------------------------------------------------
      # ------------------------------------------------------------------------
      #def add_participants(reviewers, observers)
      #end

      # @param [Object] command
      # @param [Object] args
      # @return [Object]
      def execute_admin_command(command, args)
        execute_command("admin review #{command} #{args}")
      end

    end
  end
end

