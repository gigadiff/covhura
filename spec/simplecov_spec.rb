require_relative "../lib/simplecov"

describe SimpleCov do
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
    let(:coverage) { [
      {number: 1, hits: 5, type: :unknown},
      {number: 2, hits: 5, type: :unknown},
      {number: 4, hits: 1, type: :unknown},
      {number: 5, hits: 0, type: :unknown},
      {number: 6, hits: 1, type: :unknown}
    ] }

    let(:report) { {
      file_name => coverage
    } }

    subject { instance.translate(doc) }

    it "translates" do
      expect(subject).to eq(report)
    end
  end
end
