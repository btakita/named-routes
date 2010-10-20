require "rake"
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "named-routes"
    s.summary = "A simple and generic named routes api. It works really well with Sinatra."
    s.email = "brian.takita@gmail.com"
    s.homepage = "http://github.com/btakita/named-routes"
    s.summary = "A simple and generic named routes api. It works really well with Sinatra."
    s.authors = ["Brian Takita"]
    s.files = FileList[
      '[A-Z]*',
      '*.rb',
      'lib/**/*.rb',
      'spec/**/*.rb'
    ].to_a
    s.test_files = Dir.glob('spec/*_spec.rb')
    s.has_rdoc = true
    s.extra_rdoc_files = [ "README.md", "CHANGES" ]
    s.rdoc_options = ["--main", "README.md", "--inline-source", "--line-numbers"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
