class Report::SimpleCov
  def translate(json)
    json
      .reduce({}) do |acc, (_test_runner, results)|
        results["coverage"].each do |file_path, file_coverage|
          acc[file_path] ||= {}
          file_coverage.each_with_index do |line_coverage, i|
            next if line_coverage.nil?
            line_num = i + 1
            old_coverage = acc[file_path][line_num]
            acc[file_path][line_num] = old_coverage.nil? ?
              line_coverage :
              line_coerage + old_coverage
          end
        end
        acc
      end
      .reduce({}) do |acc, (file_name, lines)|
        acc[file_name] ||= {}
        acc[file_name][:lines] = lines.reduce({}) do |bcc, (line_num, hits)|
          bcc[line_num] = {
            hits: hits,
            type: :unknown
          }
          bcc
        end
        acc
      end
  end
end
