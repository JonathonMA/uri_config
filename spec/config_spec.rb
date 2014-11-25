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
  end
end
