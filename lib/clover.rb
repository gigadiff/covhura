class Clover
  def translate(doc)
    doc
      .xpath("//file")
      .reduce({}) do |acc, file|
        acc[file.attr("path")] = file
          .xpath("line")
          .map do |line|
            {
              number: line.attr("num"),
              hits: line.attr("count"),
              type: line.attr("type") == "cond" ? :condition : :statement
            }
          end
        acc
      end
  end
end
