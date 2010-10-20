require "rubygems"

$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/../lib"))
require "named-routes"
require "rspec"

ARGV.push("-b")
unless ARGV.include?("--format") || ARGV.include?("-f")
  ARGV.push("--format", "nested")
end

require 'rr'

RSpec.configure do |c|
  c.mock_with :rr
#  c.filter_run :focus => true
end
