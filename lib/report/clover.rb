class Report::Clover
  def translate(doc)
    doc
      .xpath("//file")
      .reduce({}) do |acc, file|
        file_path = file.attr("path") || file.attr("name")
        acc[file_path] ||= {}
        acc[file_path][:lines] = file
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
