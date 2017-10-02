require "nokogiri"

require_relative "../lib/cobertura"

describe Cobertura do
  let(:instance) { described_class.new }

  let(:data) { <<-EOS
  <?xml version="1.0" ?>
  <!DOCTYPE coverage
    SYSTEM 'http://cobertura.sourceforge.net/xml/coverage-04.dtd'>
  <coverage branch-rate="0.956140350877" branches-covered="109" branches-valid="114" complexity="0" line-rate="0.983606557377" lines-covered="180" lines-valid="183" timestamp="1504063402" version="2.0.3">
    <sources>
      <source>.</source>
    </sources>
    <packages>
      <package branch-rate="0.956043956044" complexity="0" line-rate="0.986486486486" name="src">
        <classes>
          <class branch-rate="0.0" complexity="0" filename="src/applyMiddleware.js" line-rate="1.0" name="src.applyMiddleware.js">
            <methods>
              <method branch-rate="1.0" line-rate="1.0" name="(anonymous_2)" signature="">
                <lines>
                  <line branch="false" hits="4" number="20"/>
                </lines>
              </method>
              <method branch-rate="1.0" line-rate="1.0" name="(anonymous_1)" signature="">
                <lines>
                  <line branch="false" hits="4" number="20"/>
                </lines>
              </method>
              <method branch-rate="1.0" line-rate="1.0" name="(anonymous_4)" signature="">
                <lines>
                  <line branch="false" hits="6" number="29"/>
                </lines>
              </method>
              <method branch-rate="1.0" line-rate="1.0" name="applyMiddleware" signature="">
                <lines>
                  <line branch="false" hits="4" number="19"/>
                </lines>
              </method>
              <method branch-rate="1.0" line-rate="1.0" name="(anonymous_3)" signature="">
                <lines>
                  <line branch="false" hits="4" number="27"/>
                </lines>
              </method>
            </methods>
            <lines>
              <line branch="false" hits="4" number="20"/>
              <line branch="false" hits="4" number="21"/>
              <line branch="false" hits="4" number="22"/>
              <line branch="false" hits="4" number="23"/>
              <line branch="false" hits="4" number="25"/>
              <line branch="false" hits="4" number="27"/>
              <line branch="false" hits="6" number="29"/>
              <line branch="false" hits="4" number="30"/>
              <line branch="false" hits="4" number="32"/>
            </lines>
          </class>
        </classes>
      </package>
    </packages>
  </coverage>
  EOS
  }

  let(:doc) { Nokogiri::XML(data) }

  context ".translate" do
    let(:lines) { {
      20 => {hits: 4, type: :statement},
      21 => {hits: 4, type: :statement},
      22 => {hits: 4, type: :statement},
      23 => {hits: 4, type: :statement},
      25 => {hits: 4, type: :statement},
      27 => {hits: 4, type: :statement},
      29 => {hits: 6, type: :statement},
      30 => {hits: 4, type: :statement},
      32 => {hits: 4, type: :statement}
    } }
    let(:coverage) { { lines: lines } }

    let(:report) { {
      "src/applyMiddleware.js" => coverage
    } }

    subject { instance.translate(doc) }

    it "translates" do
      expect(subject).to eq(report)
    end
  end
end
