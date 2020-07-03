# -*- encoding: utf-8 -*-
# stub: gmail_xoauth 0.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "gmail_xoauth".freeze
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nicolas Fouch\u00E9".freeze]
  s.date = "2016-08-30"
  s.description = "Get access to Gmail IMAP and STMP via OAuth, using the standard Ruby Net libraries".freeze
  s.email = ["nicolas.fouche@gmail.com".freeze]
  s.homepage = "https://github.com/nfo/gmail_xoauth".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Get access to Gmail IMAP and STMP via OAuth, using the standard Ruby Net libraries".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>.freeze, [">= 0.3.6"])
      s.add_development_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    else
      s.add_dependency(%q<oauth>.freeze, [">= 0.3.6"])
      s.add_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<oauth>.freeze, [">= 0.3.6"])
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
  end
end
