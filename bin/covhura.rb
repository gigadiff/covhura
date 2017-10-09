#! /usr/bin/env ruby

require_relative "../lib/covhura"

puts Covhura.new.translate(File.read(ARGV.first)).to_json()
