# TN: -> start of record
# SF: -> file path
# FN: -> function declaration (line#,func_name)
# FNDA: function coverage (count,func_name)
# BRDA: branch coverage (line#,block#,branch#,count) count = - for none
# DA: line coverage
# LF: statements
# LH: statements covered
# FNF: functions
# FNH: functions covered
# BRF: branches / conditionals
# BRH: branches / conditions covered
# end_of_record: -> end of record
class LCov
  def translate(doc)
    files(doc).reduce({}) do |acc, file|
      file.shift()

      lines = lines(file)
      branches = branches(file)

      path = file.first[3..-1]
      acc[path] = {lines: merge(lines, branches)}

      acc
    end
  end

  private

  def files(doc)
    files = doc
      .lines
      .map(&:chomp)
      .reduce([[]]) do |acc, line|
        if line == "end_of_record"
          acc << []
        else
          acc.last << line
        end
        acc
      end
    files.pop()
    files
  end

  def lines(file)
    file.reduce({}) do |acc, line|
      if line[0...3] == "DA:"
        coverage = line[3..-1].split(",")
        acc[coverage.first.to_i] = coverage.last.to_i
      end
      acc
    end
  end

  def branches(file)
    file.reduce({}) do |acc, line|
      if line[0...5] == "BRDA:"
        coverage = line[5..-1].split(",")
        acc[coverage.first.to_i] = true
      end
      acc
    end
  end

  # TODO: Technically this misses branches that aren't covered in DA.
  def merge(lines, branches)
    lines.reduce({}) do |acc, (num, count)|
      acc[num] = {
        hits: count,
        type: branches.has_key?(num) ? :condition : :statement
      }
      acc
    end
  end
end
