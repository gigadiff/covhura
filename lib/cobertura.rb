class Cobertura
  def translate(doc)
    doc
      .xpath("//class")
      .reduce({}) do |acc, file|
        acc[file.attr("filename")] = file
          .xpath("lines/line")
          .map do |line|
            {
              number: line.attr("number"),
              hits: line.attr("hits"),
              type: line.attr("branch") == "true" ? :condition : :statement
            }
          end
        acc
      end
  end
end
