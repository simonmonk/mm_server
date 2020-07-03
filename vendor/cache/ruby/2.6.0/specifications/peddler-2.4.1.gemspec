# -*- encoding: utf-8 -*-
# stub: peddler 2.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "peddler".freeze
  s.version = "2.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Hakan Ensari".freeze]
  s.date = "2020-05-05"
  s.email = ["me@hakanensari.com".freeze]
  s.homepage = "https://github.com/hakanensari/peddler".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A Ruby wrapper to the Amazon MWS API".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<excon>.freeze, [">= 0.50.0"])
      s.add_runtime_dependency(%q<jeff>.freeze, ["~> 2.0"])
      s.add_runtime_dependency(%q<multi_xml>.freeze, [">= 0.5.0"])
    else
      s.add_dependency(%q<excon>.freeze, [">= 0.50.0"])
      s.add_dependency(%q<jeff>.freeze, ["~> 2.0"])
      s.add_dependency(%q<multi_xml>.freeze, [">= 0.5.0"])
    end
  else
    s.add_dependency(%q<excon>.freeze, [">= 0.50.0"])
    s.add_dependency(%q<jeff>.freeze, ["~> 2.0"])
    s.add_dependency(%q<multi_xml>.freeze, [">= 0.5.0"])
  end
end
