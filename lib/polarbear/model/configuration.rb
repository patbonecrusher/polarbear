
module PolarBear

  class Configuration

    def initialize(hash)
      @configuration = hash
    end

    def url
      @configuration['url'] rescue nil
    end

    def username
      @configuration['user'] rescue nil
    end

  end

end
