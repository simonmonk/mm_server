# -*- encoding: utf-8 -*-
# stub: barby 0.6.8 ruby lib

Gem::Specification.new do |s|
  s.name = "barby".freeze
  s.version = "0.6.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tore Darell".freeze]
  s.date = "2019-05-23"
  s.description = "Barby creates barcodes.".freeze
  s.email = "toredarell@gmail.com".freeze
  s.executables = ["barby".freeze]
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze, "bin/barby".freeze]
  s.homepage = "http://toretore.github.com/barby".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "The Ruby barcode generator".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.11"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<semacode-ruby19>.freeze, ["~> 0.7"])
      s.add_development_dependency(%q<rqrcode>.freeze, ["~> 0.10"])
      s.add_development_dependency(%q<prawn>.freeze, ["~> 2.2"])
      s.add_development_dependency(%q<cairo>.freeze, ["~> 1.15"])
    else
      s.add_dependency(%q<minitest>.freeze, ["~> 5.11"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<semacode-ruby19>.freeze, ["~> 0.7"])
      s.add_dependency(%q<rqrcode>.freeze, ["~> 0.10"])
      s.add_dependency(%q<prawn>.freeze, ["~> 2.2"])
      s.add_dependency(%q<cairo>.freeze, ["~> 1.15"])
    end
  else
    s.add_dependency(%q<minitest>.freeze, ["~> 5.11"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<semacode-ruby19>.freeze, ["~> 0.7"])
    s.add_dependency(%q<rqrcode>.freeze, ["~> 0.10"])
    s.add_dependency(%q<prawn>.freeze, ["~> 2.2"])
    s.add_dependency(%q<cairo>.freeze, ["~> 1.15"])
  end
end
