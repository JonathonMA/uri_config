require 'uri_config'

module URIConfig
  class S3Config < Config
    map :access_key_id, from: :username
    map :secret_access_key, from: :password

    def bucket
      path[1..-1]
    end

    config :access_key_id, :secret_access_key, :bucket
  end

  describe S3Config do
    subject { described_class.new(url) }

    {
      "https://AKIAJBPUOK67MOQ3VVXQ:7d123FASD123sljnfdsaSADFasdfhsdf12ddFDH4@s3.amazonaws.com/bucket_name" => {
        access_key_id: "AKIAJBPUOK67MOQ3VVXQ",
        secret_access_key: "7d123FASD123sljnfdsaSADFasdfhsdf12ddFDH4",
        bucket: "bucket_name",
      },
    }.each do |url, components|
      context "with a URL of #{url}" do
        let(:url) { url }

        components.each do |key, value|
          it "has a #{key} of #{value}" do
            expect(subject.send(key)).to eq value
          end
        end

        it "has a config hash" do
          expect(subject.config).to eq components
        end
      end
    end
  end
end
