# -*- encoding: utf-8 -*-
# stub: html_to_plain_text 1.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "html_to_plain_text".freeze
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brian Durand".freeze]
  s.date = "2015-12-07"
  s.description = "A simple library for converting HTML into an approximation in plain text.".freeze
  s.email = ["bdurand@embellishedvisions.com".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze]
  s.homepage = "https://github.com/bdurand/html_to_plain_text".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze, "--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "A simple library for converting HTML into plain text.".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["> 2.6.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<bump>.freeze, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
      s.add_dependency(%q<rspec>.freeze, ["> 2.6.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<bump>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
    s.add_dependency(%q<rspec>.freeze, ["> 2.6.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<bump>.freeze, [">= 0"])
  end
end
