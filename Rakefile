#!/usr/bin/env rake
require 'rake/testtask'
require 'rubygems'
require 'rubygems/package_task'

Rake::TestTask.new do |i|
  i.libs << 'ext'
  i.options = '-v'
  i.verbose = true
end

require File.expand_path('../lib/bin_utils/version', __FILE__)
spec = Gem::Specification.new do |gem|
  gem.name          = "bin_utils"
  gem.authors       = ["Sokolov Yura 'funny-falcon'"]
  gem.email         = ["funny.falcon@gmail.com"]
  gem.description   = %q{utils for extracting binary integers from binary string and packing them back}
  gem.summary       = %q{Faster alternative to String#unpack and Array#unpack, though not as complete as those methods}
  gem.homepage      = "https://github.com/funny-falcon/bin_utils"

  file = FileList["lib/**/*.rb"] + FileList["test/**/*.rb"]
  if RUBY_ENGINE == 'jruby'
    gem.files       = file + FileList["ext/**/*.jar"]
  else
    gem.extensions  = ["ext/bin_utils/extconf.rb"]
    gem.files       = file + FileList["ext/**/*.c"]
  end
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ["lib", "ext"]

  gem.required_ruby_version = '>= 1.9.1'
  gem.platform      = Gem::Platform::RUBY

  gem.add_development_dependency 'rake-compiler', '~> 0.9'
  gem.version       = BinUtils::VERSION
end

Gem::PackageTask.new(spec) do |pkg|
end

def precompile(t)
  puts "PRECOMPILE #{t.name}"
  require 'erb'
  result = ERB.new(File.read(t.source), nil, "-%").result
  File.open(t.name, 'w'){|fl| fl.write result }
end

rule '.java' => '.java.erb' do |t| precompile(t) end
rule '.c' => '.c.erb' do |t| precompile(t) end

if RUBY_PLATFORM =~ /java/
  task :compile => ['ext/bin_utils/JavaUtils.java']
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new("bin_utils", spec) do |ext|
    ext.lib_dir = 'ext/bin_utils'
  end
else
  require 'rake/extensiontask'
  task :compile => ['ext/bin_utils/native.c']
  Rake::ExtensionTask.new("bin_utils", spec) do |ext|
    ext.lib_dir = 'ext/bin_utils'
  end
end
