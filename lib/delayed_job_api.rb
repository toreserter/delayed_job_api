require 'delayed_job_api/version'
require 'delayed_job_api/configuration'
require 'delayed_job_api/application/app'
require 'delayed_job_api/railtie' if defined?(Rails)


module DelayedJobApi
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= ::DelayedJobApi::Configuration.new
  end

  def self.reset
    @configuration = ::DelayedJobApi::Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end