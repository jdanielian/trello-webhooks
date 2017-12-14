require 'logger'

# for Rack logger to use regular logger this alias needs to be added to basic ::Logger
class ::Logger; alias_method :write, :<<; end

module SimpleLogger
  # This is the magical bit that gets mixed into your classes
  def logger
    SimpleLogger.logger
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

require 'roda'

module AppLogger
  module InstanceMethods
    include SimpleLogger

    def log
      logger
    end

  end

end

Roda::RodaPlugins::register_plugin(:app_logger, AppLogger)
