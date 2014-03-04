require 'polarbear/utils/executor'
require 'addressable/uri'

module PolarBear
  module Command

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    class Report

      def initialize
        @default_args = {
            ':page' => 'ReportReviewList',
            ':formSubmittedreportConfig' => 1,
            ':fileCountVis' => 'y',
            ':numDefectsVis' => 'y',
            ':phaseVis' => 'y',
            ':reviewAuthorUserNameVis' => 'y',
            ':reviewCreationDateVis' => 'y',
            ':reviewCreatorUserLoginVis' => 'y',
            ':reviewIdVis' => 'y',
            ':reviewTitleVis' => 'y',
            ':review_idleVis' => 'y',
            ':reviewerDurationVis' => 'y',
            ':sort0_col' => 'reviewId',
            ':sort0_order' => 'desc',
            ':data-format' => 'csv'
        }
      end

      def request_active_report_for(username)
        args = generate_args

        args[':participantFilter'] = username
        args[':phaseFilter'] = 'inprogress'

        execute_report_request(args)
      end

      def request_report_in_planning_for(username)
        args = generate_args

        args[':participantFilter'] = username
        args[':phaseFilter'] = 'Planning'

        execute_report_request(args)
      end

      def get_review_with_title_for(username, title)
        args = generate_args

        args[':participantFilter'] = username
        args[':phaseFilter'] = 'Planning'
        args[':reviewTitleFilter'] = "target%3D#{URI::encode title}%7C%7C%7Ctype%3Dcontains"

        execute_report_request(args)
      end

      private

      def generate_args
        @default_args.clone
      end

      def execute_report_request(args)
        query_string = args.to_a.map { |x| "#{x[0].gsub(/:/,'')}=#{x[1]}" }.join('&')
        review_report = Utils::Executor.instance.execute_command("--quiet admin wget \"/go?#{query_string}\"")

        review_report = review_report.gsub(/'/,' ')
        review_report = review_report.gsub(/"/,' ')

        CSV.parse(review_report, headers: true, :header_converters => :symbol).map {|row| row.to_hash}
      end

    end

  end
end