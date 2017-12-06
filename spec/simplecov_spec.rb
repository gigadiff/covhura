require_relative "../lib/report/simplecov"

describe Report::SimpleCov do
  let(:instance) { described_class.new }
  let(:file_name) { "/home/root/repo/foo" }

  let(:doc) { {
    "RSpec" => {
      "coverage" => {
        file_name => [
          5,
          5,
          nil,
          1,
          0,
          1
        ]
      }
    }
  } }

  describe ".translate" do
    let(:lines) { {
      1 => {hits: 5, type: :unknown},
      2 => {hits: 5, type: :unknown},
      3 => {hits: nil, type: :unknown},
      4 => {hits: 1, type: :unknown},
      5 => {hits: 0, type: :unknown},
      6 => {hits: 1, type: :unknown}
    } }
    let(:coverage) { { lines: lines } }

    let(:report) { {
      file_name => coverage
    } }

    subject { instance.translate(doc) }

    it "translates" do
      expect(subject).to eq(report)
    end
  end
end
