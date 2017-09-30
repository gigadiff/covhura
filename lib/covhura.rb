require "json"
require "nokogiri"

require_relative "clover"
require_relative "lcov"
require_relative "cobertura"
require_relative "simplecov"

class Covhura
  def translate(doc)
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

  def merge(old, new)
    new.reduce(old) do |acc, (file_path, file_coverage)|
      acc[file_path] ||= []

      old_coverage = old[file_path].reduce({}) do |bcc, line|
        bcc[line[:number]] = line
        bcc
      end

      file_coverage.each do |line|
        old_coverage[line[:number]] = old_coverage.has_key?(line[:number]) ?
          merge_line(old_coverage[line[:number]], line) :
          line
      end

      acc[file_path] = old_coverage.reduce([]) do |bcc, (line_num, line)|
        bcc << line
        bcc
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
