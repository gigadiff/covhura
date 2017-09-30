require "json"
require "nokogiri"

require_relative "clover"
require_relative "lcov"
require_relative "cobertura"
require_relative "simplecov"

class Covhura
  def translate(file)
    doc = File.read(file)
    lines = doc.lines
    first_line = lines
      .detect { |line| line.strip() != "" }
      .strip()

    if xml?(doc)
      doc = Nokogiri::XML(doc)
      if clover?(doc)
        translator = Clover
      elsif cobertura?(doc)
        translator = Cobertura
      end
    elsif json?(first_line)
      doc = JSON.parse(doc)
      translator = SimpleCov
    elsif lcov?(first_line)
      translator = LCov
    end

    raise "Coverage Format Not Supported" if !defined?(translator) || translator.nil?

    translator.new.translate(doc)
  end

  private

  def clover?(doc)
    doc.xpath("/coverage")&.attr("clover") != nil
  end

  def cobertura?(doc)
    doc.internal_subset.to_s.match(/cobertura/i) != nil
  end

  def xml?(first_line)
    first_line[0...5] == "<?xml"
  end

  def json?(first_line)
    first_line[0] == "{" || first_line[0] == "["
  end

  def lcov?(first_line)
    first_line[0...3] == "TN:"
  end
end
