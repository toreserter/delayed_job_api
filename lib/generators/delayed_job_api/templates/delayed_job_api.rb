require 'delayed_job_api'

DelayedJobApi.configure do |c|
  c.client_id = 'your-client-id-here'
  c.client_secret = 'your-client-secret-here'
end