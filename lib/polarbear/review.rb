
require 'nori'


module PolarBear

  class Review

    def initialize(xml, admin_interface)
      @review_content = xml
      @admin_interface = admin_interface
    end

    def phase
      @review_content[:general][:phase] rescue nil
    end

    def active?
      %w(Planning Inspection Rework).include?(phase)
    end

    def review_id
      @review_content[:general][:review_id] rescue nil
    end

    def creator
      @review_content[:general][:creator] rescue nil
    end

    def creation_date
      @review_content[:general][:creation_date] rescue nil
    end

    def title
      @review_content[:general][:title] rescue nil
    end

  end

end