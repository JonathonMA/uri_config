# UriConfig

[![Build Status](https://travis-ci.org/JonathonMA/uri_config.svg?branch=master)](https://travis-ci.org/JonathonMA/uri_config)

Configure services via URI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uri_config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uri_config

## Usage

Extract credentials from generic URIs:

```ruby
config = URIConfig::Config.new("https://my_user:my_pass@s3.amazonaws.com/a_path")

config.username # => "my_user"
config.password # => "my_password"
config.path # => "/bucket_name"
```

Build wrapper classes for more specific configuration hashes:

```ruby
class S3Config < Config
  alias_method :access_key_id, :username
  alias_method :secret_access_key, :password

  def bucket
    path[1..-1]
  end

  config :access_key_id, :secret_access_key, :bucket
end

config = S3Config.new("https://AKIAJUSERNAME:abcd12345678@s3.amazonaws.com/bucket_name")

config.access_key_id # => "AKIAJUSERNAME"
config.secret_access_key # => "abcd12345678"
config.bucket # => "bucket_name"

config.config # => {access_key_id: "AKIAJUSERNAME, secret_access_key: "abcd12345678", bucket: "bucket_name" }
```

Use the `.configure_from` helper to configure based on environment variables, e.g. config/initializers/mandrill.rb:

```ruby
require "uri_config/action_mailer_config"

URIConfig::ActionMailerConfig.configure_from('ACTION_MAILER_URL') do |c|
  Rails.application.config.action_mailer.smtp_settings = c.config
end
```

## Contributing

1. Fork it ( https://github.com/JonathonMA/uri_config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
