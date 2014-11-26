require 'uri_config'

module URIConfig
  class ActionMailerConfig < URIConfig::Config
    map :address, from: :host
    map :user_name, from: :username

    parameter :authentication
    parameter :domain

    def enable_starttls_auto
      uri.scheme == "smtps"
    end

    config(
      :address,
      :port,
      :enable_starttls_auto,
      :user_name,
      :password,
      :authentication,
      :domain,
    )
  end
end
