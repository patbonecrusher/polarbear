require 'file/find'
require 'os'

module PolarBear
  module Utils

    # --------------------------------------------------------------------------
    # Usage: using PolarBear::Utils
    #        find_ccollab_executable
    # --------------------------------------------------------------------------
    # @return [Object]
    def find_ccollab_executable
      if OS.mac?
        rule = File::Find.new( 
            :pattern => 'ccollab',
            :follow => false, 
            :path => %w(/Applications))
      else OS.windows?
        rule = File::Find.new( 
            :pattern => 'ccollab.exe',
            :follow => false, 
            :path => ['c:/Program Files/Code Collaborator Client'])
      end
      
      # We use the block form to automatically stop once we find something.
      rule.find { |f| return f }

      raise 'ccollab not found'
    end

  end
end
