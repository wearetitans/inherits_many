# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "inherits_many/version"

Gem::Specification.new do |s|
  s.name        = "inherits_many"
  s.version     = InheritsMany::VERSION
  s.authors     = ["Andrew Culver"]
  s.email       = ["andrew.culver@gmail.com"]
  s.homepage    = "http://github.com/wearetitans/inherits_many"
  s.summary     = %q{Allow has_many relationships to inherit associated objects from a parent object's has_many association.}
  s.description = %q{Example: "If a restaurant can have many menu items and a chain has many menu items, ensure all restaurants have the menu items of the chain they belong to."}

  s.rubyforge_project = "inherits_many"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "activerecord"
end
