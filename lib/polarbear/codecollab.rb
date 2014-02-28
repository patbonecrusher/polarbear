require 'polarbear/utils/ccollab_locator'
require 'polarbear/command/admin'
require 'polarbear/review'
require 'nori'

module PolarBear

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  class CodeCollab
    include PolarBear::Utils

    # :stopdoc:
    VALID_OPTIONS = %w/
      password
      username
      url
      quiet
      debug
      interactive
      browser_enabled
      ccollab_execpath
    /
    # :startdoc:

    attr_accessor :options

    attr_accessor :url
    attr_accessor :username
    attr_accessor :password

    attr_accessor :quiet
    attr_accessor :debug
    attr_accessor :interactive
    attr_accessor :browser_enabled

    attr_accessor :ccollab_execpath

    attr_reader :admin

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # @param [Object] options
    def initialize(options = {})
      @options = options
      puts @ccollab_execpath
      @ccollab_execpath = find_ccollab_executable
      validate_and_set_options(options) unless options.empty?

      puts @ccollab_execpath

      @admin = Command::Admin.new(@ccollab_execpath)
    end

    def active_reviews(username)
      reviews = Array.new
      review_ids = @admin.get_open_reviews_id
      review_xml = @admin.get_review_xml_info(review_ids.join(' '))

      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      @reviews_content = parser.parse(review_xml)
      @reviews_content[:reviews][:review].each() do |review_hash|
        review = Review.new(review_hash, @admin)
        reviews.push review if review.creator == username
      end

      reviews
    end

    def last_review
      Review.new(admin.get_review_xml_info('last'), @admin)
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
