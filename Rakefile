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

  gem.files         = (Dir['lib/**/*'] + Dir['test/**/*']).grep(/\.rb$/) +
                      (RUBY_ENGINE == 'jruby' ? Dir['ext/**/*'].grep(/\.jar$/) : Dir['ext/**/*'].grep(/\.(rb|c)$/))
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.extensions    = ["ext/bin_utils/extconf.rb"]  unless RUBY_ENGINE == 'jruby'
  gem.require_paths = ["lib", "ext"]

  gem.required_ruby_version = '>= 1.9.1'
  gem.platform      = Gem::Platform::RUBY

  gem.add_development_dependency 'rake-compiler'
  gem.version       = BinUtils::VERSION
end

Gem::PackageTask.new(spec) do |pkg|
end

if RUBY_PLATFORM =~ /java/
  task :compile => :precompile
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new("bin_utils", spec) do |ext|
    ext.lib_dir = 'ext/bin_utils'
  end
  javaf = File.expand_path('../ext/bin_utils/JavaUtils.java', __FILE__)
  file javaf => ["#{javaf}.erb"] do
    require 'erb'
    puts "PRECOMPILE"
    File.open(javaf, 'w') do |fl|
      fl.write ERB.new(File.read("#{javaf}.erb"), nil, "-%").result
    end
  end

  task :precompile => [javaf]
else
  require 'rake/extensiontask'
  Rake::ExtensionTask.new("bin_utils", spec) do |ext|
    ext.lib_dir = 'ext/bin_utils'
  end
end
