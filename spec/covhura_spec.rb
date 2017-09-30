require_relative "../lib/covhura"

describe Covhura do
  context ".translate" do
    let(:instance) { described_class.new }
    let(:file) { File.join(File.dirname(__FILE__), "fixtures", report_name) }

    context "when clover report" do
      let(:report_name) { "clover.xml" }

      it "tranlates clover" do
        expect_any_instance_of(Clover).to receive(:translate)
        instance.translate(file)
      end
    end

    context "when cobertura report" do
      let(:report_name) { "cobertura.xml" }

      it "tranlates clover" do
        expect_any_instance_of(Cobertura).to receive(:translate)
        instance.translate(file)
      end
    end

    context "when lcov report" do
      let(:report_name) { "lcov.info" }

      it "tranlates clover" do
        expect_any_instance_of(LCov).to receive(:translate)
        instance.translate(file)
      end
    end

    context "when Simple Cov report" do
      let(:report_name) { "simplecov.json" }

      it "tranlates clover" do
        expect_any_instance_of(SimpleCov).to receive(:translate)
        instance.translate(file)
      end
    end

    context "when unknown" do
      let(:report_name) { "luacov.out" }
      it "raises unknown format" do
        expect { instance.translate(file) }.to raise_error("Coverage Format Not Supported")
      end
    end
  end
end
