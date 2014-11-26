require 'uri_config/action_mailer_config'

module URIConfig
  describe ActionMailerConfig do
    subject { described_class.new(url) }

    {
      "smtps://MANDRILL_USERNAME:MANDRILL_PASSWORD@smtp.mandrillapp.com:25/?authentication=login&domain=yourdomain.com" => {
        address: "smtp.mandrillapp.com",
        port: 25,
        enable_starttls_auto: true,
        user_name: "MANDRILL_USERNAME",
        password: "MANDRILL_PASSWORD",
        authentication: 'login',
        domain: 'yourdomain.com',
      },
      "smtp://MANDRILL_USERNAME:MANDRILL_PASSWORD@smtp.mandrillapp.com:2525/?authentication=plain&domain=yourdomain.com" => {
        address: "smtp.mandrillapp.com",
        port: 2525,
        enable_starttls_auto: false,
        user_name: "MANDRILL_USERNAME",
        password: "MANDRILL_PASSWORD",
        authentication: 'plain',
        domain: 'yourdomain.com',
      },
    }.each do |url, components|
      context "with a URL of #{url}" do
        let(:url) { url }

        components.each do |key, value|
          it "has a #{key} of #{value}" do
            expect(subject.send(key)).to eq value
          end
        end
      end
    end
  end
end
