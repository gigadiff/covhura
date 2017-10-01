class Clover
  def translate(doc)
    doc
      .xpath("//file")
      .reduce({}) do |acc, file|
        acc[file.attr("path")] = file
          .xpath("line")
          .map do |line|
            {
              number: line.attr("num").to_i,
              hits: line.attr("count").to_i,
              type: line.attr("type") == "cond" ? :condition : :statement
            }
          end
        acc
      end
  end
end
