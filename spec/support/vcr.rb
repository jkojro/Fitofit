VCR.configure do |c|
  c.cassette_library_dir  = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = false
  c.ignore_localhost = true
  c.ignore_hosts 'codeclimate.com', 'elasticsearch', 'elasticsearch-test'
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
  c.filter_sensitive_data("<google_api_key>") do
    Rails.application.credentials[:google_maps_api_key]
  end
end
