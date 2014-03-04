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

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # @param [Object] options
    def initialize(options = {})

      @options = options
      validate_and_set_options(options) unless options.empty?

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

    # @param [Object] review_data
    def create_review(review_data = {})
      puts review_data

      options = PolarBear::Command::GlobalOptions.new()
      batch = PolarBear::Command::Batch.new(options)

      batch.add_command(':admin_review_create', {':title' => "#{review_data[:title]}"}) if (review_data.has_key?(:title))
      batch.add_command(':admin_review_create/', '') if (!review_data.has_key?(:title))

      if review_data.has_key?(:reviewers) || review_data.has_key?(:observers)
        add_participants_content = { }
        add_participants_content.compare_by_identity
        review_data[:reviewers].each {|reviewer| add_participants_content[':participant'] = "reviewer=#{reviewer}" }
        review_data[:observers].each {|observer| add_participants_content[':participant'] = "observer=#{observer}" }
        add_participants_content[':review'] = 'last'
        batch.add_command(':admin_review_set-participants', add_participants_content)
        batch.add_command(':admin_review-xml', {':review' => 'last'})
      end

      batch.add_command(':admin_review-xml', {':review' => 'last'})

      review_xml = @admin.execute_batch_command(batch)
      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      review_hash = parser.parse(review_xml)
      Review.new(review_hash[:reviews][:review])
    end

    def delete_reviews(reviews)
      options = PolarBear::Command::GlobalOptions.new()
      batch = PolarBear::Command::Batch.new(options)

      reviews.each do |review|
        puts review.inspect
        batch.add_command('admin_review_cancel', {':review' => "#{review.review_id}"})
      end

      @admin.execute_batch_command(batch)
    end

    def login(url, username, password)
      @commands[:admin].execute_command("login #{url} #{username} #{password}")
    end

    def logout(url, username, password)
      @admin.execute_command("login #{url} #{username} #{password}")
    end

    private

    # This validates that the keys are valid. If they are, it sets the value
    # of that key's corresponding method to the given value. If a key ends
    # with a '?', it's validated as a File method.
    #
    def validate_and_set_options(options)
      options.each do |key, value|
        key = key.to_s.downcase

        if key[-1].chr == '?'
          sym = key.to_sym

          unless CodeCollab.respond_to?(sym)
            raise ArgumentError, "invalid option '#{key}'"
          end
        else
          unless VALID_OPTIONS.include?(key)
            raise ArgumentError, "invalid option '#{key}'"
          end

          send("#{key}=", value)
        end
      end
    end

  end

end
