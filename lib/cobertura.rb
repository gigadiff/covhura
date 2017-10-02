class Cobertura
  def translate(doc)
    doc
      .xpath("//class")
      .reduce({}) do |acc, file|
        acc[file.attr("filename")] ||= {}
        acc[file.attr("filename")][:lines] = file
          .xpath("lines/line")
          .reduce({}) do |bcc, line|
            line_num = line.attr("number").to_i
            bcc[line_num] = {
              hits: line.attr("hits").to_i,
              type: line.attr("branch") == "true" ? :condition : :statement
            }
            bcc
          end
        acc
      end
  end
end
