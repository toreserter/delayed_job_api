module DelayedJobApi
  class InstallGenerator < Rails::Generators::Base
    desc 'Installs DelayedJobApi'
    source_root File.expand_path("../../templates", __FILE__)

    def install
      template "delayed_job_api.rb", "config/initializers/delayed_job_api.rb"
    end

  end
end