require 'rubygems'
spec = Gem::Specification.new do |s|
  s.name="Bauble"
  s.version="0.1"
  s.author="unclebob"
  s.email="unclebob@objectmentor.com"
  s.platform=Gem::Platform::RUBY
  s.summary="A simple sub-module system."
  s.require_path = "lib"
  s.files=["lib/bauble.rb"]
  s.autorequire = "bauble"
  s.has_rdoc = true
end

Gem::manage_gems
Gem::Builder.new(spec).build