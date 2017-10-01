require "nokogiri"

require_relative "../lib/clover"

describe Clover do
  let(:instance) { described_class.new }

  let(:data) { <<-EOS
  <?xml version="1.0" encoding="UTF-8"?>
  <coverage generated="1504056655580" clover="3.2.0">
    <project timestamp="1504056655580" name="All files">
      <metrics statements="183" coveredstatements="180" conditionals="114" coveredconditionals="109" methods="50" coveredmethods="49" elements="347" coveredelements="338" complexity="0" loc="183" ncloc="183" packages="3" files="11" classes="11">
        <package name="src">
          <metrics statements="148" coveredstatements="146" conditionals="91" coveredconditionals="87" methods="30" coveredmethods="29"/>
          <file name="applyMiddleware.js" path="/home/root/redux/src/applyMiddleware.js">
            <metrics statements="9" coveredstatements="9" conditionals="0" coveredconditionals="0" methods="5" coveredmethods="5"/>
            <line num="20" count="4" type="stmt"/>
            <line num="21" count="4" type="stmt"/>
            <line num="22" count="4" type="stmt"/>
            <line num="23" count="4" type="stmt"/>
            <line num="25" count="4" type="stmt"/>
            <line num="27" count="4" type="stmt"/>
            <line num="29" count="6" type="stmt"/>
            <line num="30" count="4" type="stmt"/>
            <line num="32" count="4" type="stmt"/>
          </file>
        </package>
      </metrics>
    </project>
  </coverage>
  EOS
  }

  let(:doc) { Nokogiri::XML(data) }

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
