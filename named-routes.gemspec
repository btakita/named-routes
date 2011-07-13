Gem::Specification.new do |s|
  s.name = %q{named-routes}
  s.version = File.read("#{File.dirname(__FILE__)}/VERSION").strip

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Takita"]
  s.date = %q{2011-01-19}
  s.email = %q{brian.takita@gmail.com}
  s.extra_rdoc_files = [
    "CHANGES",
    "README.md"
  ]
  s.files = [
    "CHANGES",
    "Gemfile",
    "Gemfile.lock",
    "MIT.LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/named-routes.rb",
    "lib/named-routes/routes.rb",
    "lib/named-routes/schemed_uri.rb",
    "spec/named-routes/routes_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/btakita/named-routes}
  s.rdoc_options = ["--main", "README.md", "--inline-source", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A simple and generic named routes api. It works really well with Sinatra.}

  s.add_runtime_dependency "activesupport", ">=3.0.0"
end

