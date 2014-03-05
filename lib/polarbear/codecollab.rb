require 'polarbear/utils/ccollab_locator'
require 'polarbear/command/admin'
require 'polarbear/command/report'
require 'polarbear/command/config'

require 'polarbear/model/review'
require 'polarbear/model/configuration'

require 'nori'
require 'open-uri'
require 'csv'

module PolarBear

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  class CodeCollab
    include PolarBear::Utils

    # :stopdoc:
    VALID_OPTIONS = %w/
      ccollab_execpath
    /
    # :startdoc:

    attr_accessor :ccollab_execpath
    attr_reader :commands
    attr_reader :configuration

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # @return [Object]
    def initialize

      @ccollab_execpath = find_ccollab_executable
      Utils::Executor.instance.set_codecollab_exec_path(@ccollab_execpath)
      puts @ccollab_execpath

      @commands = {}
      @commands[:admin] = Command::Admin.new
      @commands[:config] = Command::Config.new
      @commands[:report] = Command::Report.new

      @configuration = Configuration.new(@commands[:config].load_from_local_settings)

    end

    def active_reviews
      reports_result = @commands[:report].request_active_report_for(@configuration.username)
      reports_result.map { |report| Review.new(report) }
    end

    def reviews_in_planning
      reports_result = @commands[:report].request_report_in_planning_for(@configuration.username)
      reports_result.map { |report| Review.new(report) }
    end

    def get_review_with_title(title)
      reports_result = @commands[:report].get_review_with_title(@configuration.username, title)
      reports_result.map { |report| Review.new(report) }
    end

    def last_review
      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      review_hash = parser.parse(@commands[:admin].get_review_xml_info('last'))
      Review.new(review_hash[:reviews][:review][:general])
    end

    def delete_reviews(reviews)
      options = PolarBear::Command::GlobalOptions.new()
      batch = PolarBear::Command::Batch.new(options)

      reviews.each do |review|
        puts review.inspect
        batch.add_command('admin_review_cancel', {':review' => "#{review.id}"})
      end

      batch.execute
    end

    def login(url, username, password)
      Utils::Executor.instance.execute_command("login #{url} #{username} #{password}")
    end

    def logout
      Utils::Executor.instance.execute_command('logout')
    end


  end

end
