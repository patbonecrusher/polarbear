
module PolarBear

  class Configuration

    def initialize(config_data)

      keyValues = []
      config_data.each_line { |l|
        if l.include? '='
          keyValues.push(l.gsub(/\s+/, '').chomp)
        end
      }

      @configuration = Hash[keyValues.each.map { |kv| kv.chomp.split('=', 2) }]
    end

    def url
      return @configuration['url'] rescue nil
    end

    def username
      return @configuration['user'] rescue nil
    end

  end

end
