require_relative "../lib/covhura"

describe Covhura do
  let(:instance) { described_class.new }

  context ".translate" do
    let(:file_path) { File.join(File.dirname(__FILE__), "fixtures", report_name) }
    let(:file) { File.read(file_path) }

    context "when clover report" do
      let(:report_name) { "clover.xml" }

      it "tranlates clover" do
        expect_any_instance_of(Report::Clover).to receive(:translate)
        instance.translate(file)
      end
    end

    context "when cobertura report" do
      let(:report_name) { "cobertura.xml" }

      it "tranlates clover" do
        expect_any_instance_of(Report::Cobertura).to receive(:translate)
        instance.translate(file)
      end
    end

    context "when lcov report" do
      let(:report_name) { "lcov.info" }

      it "tranlates clover" do
        expect_any_instance_of(Report::LCov).to receive(:translate)
        instance.translate(file)
      end
    end

    context "when Simple Cov report" do
      let(:report_name) { "simplecov.json" }

      it "tranlates clover" do
        expect_any_instance_of(Report::SimpleCov).to receive(:translate)
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

  context ".merge" do
    let(:file) { {
      lines: {
        1 => {hits: 2, type: :statement},
        3 => {hits: 2, type: :statement}
      }
    } }
    let(:file_path) { "foo" }
    let(:new_file_path) { "bar" }

    subject { instance.merge(report, new_report) }

    context "when different file" do
      let(:report) { {
        file_path => file
      } }

      let(:new_report) { {
        new_file_path => {
          lines: {
            1 => {hits: 1, type: :statement}
          }
        }
      } }

      it "creates new file" do
        expect(subject.keys).to match_array([file_path, new_file_path])
      end
    end

    context "when no previous file" do
      let(:report) { {} }
      let(:new_report) { {
        new_file_path => {
          lines: {
            1 => {hits: 1, type: :statement}
          }
        }
      } }

      it "creates new file" do
        expect(subject).to eq(new_report)
      end
    end

    context "when same file" do
      let(:report) { {
        file_path => file
      } }

      let(:new_report) { {
        file_path => {
          lines: {
            1 => {hits: 1, type: :statement}
          }
        }
      } }

      it "merges line data" do
        expect(subject[file_path][:lines][1]).to include({hits: 3, type: :statement})
      end
    end
  end
end
