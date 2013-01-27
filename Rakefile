#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new do |i|
  i.libs << 'ext'
  i.options = '-v'
  i.verbose = true
end

if RUBY_PLATFORM =~ /java/
  task :compile => :precompile
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new("bin_utils") do |ext|
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
  Rake::ExtensionTask.new("bin_utils") do |ext|
    ext.lib_dir = 'ext/bin_utils'
  end
end
