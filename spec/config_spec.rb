require 'uri_config'

module URIConfig
  describe Config do
    subject { described_class.new(url) }

    {
      "https://TESTMERCHANT1:abcd1234abcd@secure.ap.tnspayments.com" => {
        username: 'TESTMERCHANT1',
        password: 'abcd1234abcd',
        base_uri: 'https://secure.ap.tnspayments.com',
      },
      "https://foo:bar@us-west-2.amazonaws.com/namespace" => {
        username: "foo",
        password: "bar",
        path: "/namespace",
      },
      "https://AKIAJBPUOK67MOQ3VVXQ:7d123FASD123sljnfdsaSADFasdfhsdf12ddFDH4@s3.amazonaws.com/bucket_name" => {
        username: "AKIAJBPUOK67MOQ3VVXQ",
        password: "7d123FASD123sljnfdsaSADFasdfhsdf12ddFDH4",
        path: "/bucket_name",
      },
      "https://example.com:8080" => {
        host: "example.com",
        port: 8080,
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

    describe ".values_from" do
      context "when TEST_URL is not set" do
        specify do
          expect do
            URIConfig::Config.values_from("TEST_URL")
          end.to raise_error
        end
      end

      context "when TEST_URL is set" do
        before(:each) do
          ENV["TEST_URL"] = "https://user:pass@example.com/foo"
        end

        after(:each) do
          ENV["TEST_URL"] = nil
        end

        specify do
          expect(
            URIConfig::Config.values_from("TEST_URL", :username, :password),
          ).to eq(%w(user pass))
        end
      end
    end

    describe ".configure_from" do
      context "when TEST_URL is not set" do
        specify do
          expect do |b|
            URIConfig::Config.configure_from("TEST_URL", &b)
          end.not_to yield_control
        end
      end

      context "when TEST_URL is set" do
        before(:each) do
          ENV["TEST_URL"] = "https://example.com/foo"
        end

        after(:each) do
          ENV["TEST_URL"] = nil
        end

        specify do
          expect do |b|
            URIConfig::Config.configure_from("TEST_URL", &b)
          end.to yield_with_args(URIConfig::Config.new(ENV["TEST_URL"]))
        end
      end
    end

    describe ".configure_from!" do
      context "when TEST_URL is not set" do
        specify do
          expect do
            URIConfig::Config.configure_from!("TEST_URL") {}
          end.to raise_error KeyError, 'key not found: "TEST_URL"'
        end
      end

      context "when TEST_URL is set" do
        before(:each) do
          ENV["TEST_URL"] = "https://example.com/foo"
        end

        after(:each) do
          ENV["TEST_URL"] = nil
        end

        specify do
          expect do |b|
            URIConfig::Config.configure_from!("TEST_URL", &b)
          end.to yield_with_args(URIConfig::Config.new(ENV["TEST_URL"]))
        end
      end
    end

    # This behaviour will make it ... difficult to troubleshoot
    it "should not leak secrets on error" do
      url = "https://USER:secret@foo.bar.com@foo.bar.com/"

      expect do
        URIConfig::Config.new(url).password
      end.to raise_error("Invalid URI: <URL_SUPPRESSED>")
    end
  end
end
