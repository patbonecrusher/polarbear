require 'polarbear/command/batch'
require 'nori'


module PolarBear

  class Review

    attr_reader :phase
    attr_reader :review_id
    attr_reader :creator
    attr_reader :creation_date
    attr_accessor :title
    attr_accessor :participants

    def initialize(hash)

      load_data(hash)

    end

    def active?
      %w(Planning Inspection Rework).include?(@phase)
    end

    def planning?
      %w(Planning).include?(@phase)
    end

    def save!
      if @review_id.nil?
        create_new_review
      else
        save_review
      end
    end

    def cancel!

    end

    def delete!

    end

    def add_git_diff

    end

    private

    def create_new_review
      raise 'must specify 1 reviewers' if @reviewers.empty?
      raise 'must contain diffs' if @gitdiffs_args.nil?

      options = PolarBear::Command::GlobalOptions.new()
      batch = PolarBear::Command::Batch.new(options)

      batch.add_command(':admin_review_create', {':title' => "#{@title}"}) unless @title.nil?
      batch.add_command(':admin_review_create/', '') if @title.nil?

      add_participants_content = { }
      add_participants_content.compare_by_identity
      @reviewers.each {|reviewer| add_participants_content[':participant'] = "reviewer=#{reviewer}" }
      @observers.each {|observer| add_participants_content[':participant'] = "observer=#{observer}" }
      add_participants_content[':review'] = 'last'
      batch.add_command(':admin_review_set-participants', add_participants_content)

      batch.add_command(':addgitdiffs', {':review' => 'last', ':user-diff-arg' => @gitdiffs_args})
      batch.add_command(':admin_review-finish', {':review' => 'last'})
      batch.add_command(':admin_review-xml', {':review' => 'last'})

      review_xml = batch.execute
      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      review_hash = parser.parse(review_xml)
      load_data(review_hash[:reviews][:review][:general])

    end

    def save_review

    end

    def load_data(hash)
      @review_content = normalize_hash(hash)

      @phase = @review_content[:phase] rescue ''
      @review_id = @review_content[:review_id] rescue nil
      @creator = @review_content[:creator_login] rescue nil
      @creation_date = @review_content[:creation_date] rescue nil
      @title = @review_content[:title] rescue nil
      @defect_count = @review_content[:defect_count] rescue 0
      @reviewers = @review_content[:reviewers] rescue []
      @observers = @review_content[:observers] rescue []
      @gitdiffs_args = @review_content[:gitdiffs_args] rescue nil
    end

    def normalize_hash(hash)

      hash.keys.grep(/review_/).each {|k|
        newkey = k.to_s.gsub(/review_/,'').to_sym
        hash[newkey] = hash.delete k
      }

      hash

    end

  end
end