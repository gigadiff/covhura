require_relative "../lib/lcov"

describe LCov do
  let(:instance) { described_class.new }

  let(:doc) { <<-EOS
TN:
SF:/home/root/redux/src/applyMiddleware.js
FN:19,applyMiddleware
FN:20,(anonymous_1)
FN:20,(anonymous_2)
FN:27,(anonymous_3)
FN:29,(anonymous_4)
FNF:5
FNH:5
FNDA:4,applyMiddleware
FNDA:4,(anonymous_1)
FNDA:4,(anonymous_2)
FNDA:4,(anonymous_3)
FNDA:6,(anonymous_4)
DA:20,4
DA:21,4
DA:22,4
DA:23,4
DA:25,4
DA:27,4
DA:29,6
DA:30,4
DA:32,4
LF:9
LH:9
BRF:0
BRH:0
end_of_record
  EOS
  }

  context ".translate" do
    let(:coverage) { [
      {number: 20, hits: 4, type: :statement},
      {number: 21, hits: 4, type: :statement},
      {number: 22, hits: 4, type: :statement},
      {number: 23, hits: 4, type: :statement},
      {number: 25, hits: 4, type: :statement},
      {number: 27, hits: 4, type: :statement},
      {number: 29, hits: 6, type: :statement},
      {number: 30, hits: 4, type: :statement},
      {number: 32, hits: 4, type: :statement}
    ] }

    let(:report) { {
      "/home/root/redux/src/applyMiddleware.js" => coverage
    } }

    subject { instance.translate(doc) }

    it "translates" do
      expect(subject).to eq(report)
    end
  end
end
