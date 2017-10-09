class Report::Clover
  def translate(doc)
    doc
      .xpath("//file")
      .reduce({}) do |acc, file|
        acc[file.attr("path")] ||= {}
        acc[file.attr("path")][:lines] = file
          .xpath("line")
          .reduce({}) do |bcc, line|
            line_num = line.attr("num").to_i
            bcc[line_num] = {
              hits: line.attr("count").to_i,
              type: line.attr("type") == "cond" ? :condition : :statement
            }
            bcc
          end
        acc
      end
  end
end
