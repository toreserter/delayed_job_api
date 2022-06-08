require 'openssl'
require 'sinatra/base'
require 'active_support'
require 'active_record'
require 'delayed_job'
module DelayedJobApi
  class App < Sinatra::Base
    helpers do
      def request_headers
        env.inject({}) { |acc, (k, v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc }
      end
    end

    def offset
      params[:offset].to_i
    end

    def per_page
      params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
    end

    def delayed_job
      begin
        Delayed::Job
      rescue
        false
      end
    end

    before do
      authenticate!
      content_type 'application/json'
      @queues = (params[:queues] || "").split(",").map { |queue| queue.strip }.uniq.compact
    end

    get '/stats' do
      {
        enqueued: delayed_jobs(:failed, @queues).count,
        pending: delayed_jobs(:pending, @queues).count,
        working: delayed_jobs(:working, @queues).count,
        queues: delayed_jobs(nil).group(:queue).size
      }.to_json
    end

    %w(enqueued working pending failed).each do |page|
      get "/#{page}" do
        @jobs = delayed_jobs(page.to_sym, @queues).order('created_at desc, id desc').offset(offset).limit(per_page)
        @all_jobs_count = delayed_jobs(page.to_sym, @queues).count
        {
          jobs: @jobs,
          all_jobs_count: @all_jobs_count,
          offset: offset,
          per_page: per_page,
          queues: @queues
        }.to_json
      end
    end

    delete "/remove/:id" do
      get_dj(params[:id]).delete
      {
        success: true
      }.to_json
    end

    post "/requeue/failed" do
      r = delayed_jobs(:failed, @queues).update_all(:run_at => Time.now, :failed_at => nil)
      {
        success: true,
        rows_updated: r
      }.to_json
    end

    post "/requeue/:id" do
      get_dj(params[:id]).update(run_at: Time.now, failed_at: nil)
      {
        success: true
      }.to_json
    end

    post "/reload/:id" do
      get_dj(params[:id]).update(run_at: Time.now, failed_at: nil, locked_by: nil, locked_at: nil, last_error: nil, attempts: 0)
      {
        success: true
      }.to_json
    end

    post "/failed/clear" do
      r = delayed_jobs(:failed, @queues).delete_all
      {
        success: true,
        rows_deleted: r
      }.to_json
    end

    def authenticate!
      halt 401, "You are not authorized to access this resource" unless authenticated?
    end

    def authenticated?
      begin
        signature = request_headers['signature']
        a = decrypt_message(signature, DelayedJobApi.configuration.client_secret)
        a == DelayedJobApi.configuration.client_id
      rescue => e
        false
      end
    end

    def delayed_jobs(type, queues = [])
      rel = delayed_job

      rel =
        case type
        when :working
          rel.where('locked_at IS NOT NULL AND failed_at IS NULL')
        when :failed
          rel.where('last_error IS NOT NULL')
        when :pending
          rel.where(:attempts => 0, :locked_at => nil)
        else
          rel
        end

      rel = rel.where(:queue => queues) unless queues.empty?

      rel
    end

    def get_dj(id)
      begin
        delayed_job.find(id)
      rescue ActiveRecord::RecordNotFound
        halt(404)
      end
    end

    def decrypt_message(encrypted_message, key)
      cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
      cipher.key = key
      s = [encrypted_message].pack("H*").unpack("C*").pack("c*")

      cipher.update(s) + cipher.final
    end

  end
end