Gem::Specification.new do |s|
  s.name = "covhura"
  s.version = "0.0.1"
  s.date = "2018-09-09"
  s.summary = "Coverage Report Translation"
  s.description = "Translate code coverage reports into a universal format."
  s.authors = ["Brian Yahn"]
  s.email = "yahn007@outlook.com"
  s.executables << "covhura.rb"
  s.files = ["lib/covhura.rb", "lib/report.rb", "lib/report/clover.rb", "lib/report/cobertura.rb", "lib/report/lcov.rb", "lib/report/simplecov.rb"]
  s.homepage = "https://bitbucket.org/cuzzo/covhura"
  s.license = "Nonstandard"
end
