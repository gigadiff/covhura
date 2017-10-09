require "json"
require "nokogiri"

require_relative "report"
require_relative "report/clover"
require_relative "report/lcov"
require_relative "report/cobertura"
require_relative "report/simplecov"

class Covhura
  def translate(doc)
    lines = doc.lines
    first_line = lines
      .detect { |line| line.strip() != "" }
      .strip()

    if xml?(doc)
      doc = Nokogiri::XML(doc)
      if clover?(doc)
        translator = Report::Clover
      elsif cobertura?(doc)
        translator = Report::Cobertura
      end
    elsif json?(first_line)
      doc = JSON.parse(doc)
      translator = Report::SimpleCov
    elsif lcov?(first_line)
      translator = Report::LCov
    end

    raise "Coverage Format Not Supported" if !defined?(translator) || translator.nil?

    translator.new.translate(doc)
  end

  def merge(old, new)
    new.reduce(old) do |acc, (file_path, file_coverage)|
      acc[file_path] ||= {}
      acc[file_path][:lines] ||= {}

      old_coverage = acc.dig(file_path, :lines)

      file_coverage[:lines].each do |line_number, line|
        acc[file_path][:lines][line_number] = old_coverage.has_key?(line_number) ?
          merge_line(old_coverage[line_number], line) :
          line
      end

      acc
    end
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

  def merge_line(old, new)
    {
      number: old[:number],
      hits: (old[:hits] || 0) + (new[:hits] || 0),
      type: old[:type] || new[:type]
    }
  end
end
