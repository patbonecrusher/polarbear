require 'polarbear/utils/ccollab_locator'
require 'polarbear/command/admin'
require 'polarbear/command/report'
require 'polarbear/command/config'

require 'polarbear/model/review'
require 'polarbear/model/configuration'

require 'nori'
require 'open-uri'
require 'csv'
require 'etc'

module PolarBear

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  class CodeCollab
    include PolarBear::Utils

    attr_reader :commands
    attr_reader :configuration

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # @return [Object]
    def initialize

      # do we have a config file?  If so, load that and see if the exec path.
      load_pb_options

      if @polarbear_options[:ccollab_execpath].nil?
        p 'Searching for code collaborator executable...'
        @polarbear_options[:ccollab_execpath] = find_ccollab_executable
        save_pb_options
      end
      raise "Can't find code collab executable on your system" if @polarbear_options[:ccollab_execpath].nil?

      Utils::Executor.instance.set_codecollab_exec_path(@polarbear_options[:ccollab_execpath])

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
      reports_result = @commands[:report].get_review_with_title_for(@configuration.username, title)
      reports_result.map { |report| Review.new(report) }
    end

    def get_review_with_id(id)
      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      review_hash = parser.parse(@commands[:admin].get_review_xml_info(id))
      Review.new(review_hash[:reviews][:review][:general])
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

    def load_pb_options
      option_file="#{Dir.home}/.polarbear"
      if File.exist?(option_file)
        @polarbear_options = YAML.load_file(option_file)
      else
        @polarbear_options = {}
      end
    end

    def save_pb_options
      option_file="#{Dir.home}/.polarbear"
      File.open(option_file, 'w') { |fo| fo.puts @polarbear_options.to_yaml }
    end
  end

end
