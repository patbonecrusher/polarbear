require 'polarbear/command/batch'
require 'polarbear/command/admin_review'
require 'nori'


module PolarBear

  class Review

    attr_reader :phase
    attr_reader :id
    attr_reader :creator
    attr_reader :creation_date
    attr_accessor :title
    attr_accessor :participants

    def initialize(hash)
      load_data(hash)
      @admin_review = Command::AdminReview.new
    end

    def active?
      %w(Planning Inspection Rework).include?(@phase)
    end

    def planning?
      %w(Planning).include?(@phase)
    end

    def cancel!
      @admin_review.cancel(@id)
    end

    def delete!
      @admin_review.delete(@id)
    end

    def next_phase!
      @admin_review.finish(@id)
    end

    def browse
      Utils::Executor.instance.execute_command("browse --review #{@id}")
    end

    def add_git_diff(branch_a, branch_b)
      raise 'must be a valid review' if @review_content[:id].nil?
      Utils::Executor.instance.execute_command("--no-browser --quiet addgitdiffs #{@review_content[:id]} #{branch_a} #{branch_b}")
    end

    def create_it!
      can_create?

      options = PolarBear::Command::GlobalOptions.new()
      batch = PolarBear::Command::Batch.new(options)

      batch.add_command(':admin_review_create', {':title' => "#{@title}"}) unless @title.nil?
      batch.add_command(':admin_review_create/', '') if @title.nil?

      load_participants_in_batch(batch)

      batch.add_command(':admin_review_finish', {':review' => 'last'})
      batch.add_command(':admin_review-xml', {':review' => 'last'})

      update_review_from_xml(batch.execute)
    end

    private

    def can_create?
      raise 'must not already have an id' if ! @review_content[:id].nil?
      raise 'must specify authors' if @review_content[:author].nil?
      raise 'must specify 1 reviewers' if @review_content[:reviewers].empty?
      true
    end

    def load_participants_in_batch(batch)
      add_participants_content = { }
      add_participants_content.compare_by_identity
      add_participants_content[':participant'] = "author=#{@review_content[:author]}"
      @review_content[:reviewers].each {|reviewer| add_participants_content[':participant'] = "reviewer=#{reviewer}" }
      @review_content[:observers].each {|observer| add_participants_content[':participant'] = "observer=#{observer}" }
      add_participants_content[':review'] = 'last'
      batch.add_command(':admin_review_set-participants', add_participants_content)
    end

    def update_review_from_xml(xml)
      parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
      review_hash = parser.parse(xml)

      load_data(review_hash[:reviews][:review][:general])
    end

    def load_data(hash)
      @review_content = normalize_hash(hash)

      @phase = @review_content[:phase] rescue ''
      @id = @review_content[:id] rescue nil
      @creator = @review_content[:creator_login] rescue nil
      @creation_date = @review_content[:creation_date] rescue nil
      @title = @review_content[:title] rescue nil
      @defect_count = @review_content[:defect_count] rescue 0
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