# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bin_utils/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sokolov Yura 'funny-falcon'"]
  gem.email         = ["funny.falcon@gmail.com"]
  gem.description   = %q{utils for extracting binary integers from binary string and packing them back}
  gem.summary       = %q{Faster alternative to String#unpack and Array#unpack, though not as complete as those methods}
  gem.homepage      = "https://github.com/funny-falcon/bin_utils"

  gem.files         = Dir['ext/**/*'].grep(/\.(rb|c|jar)$/) +
                      (Dir['lib/**/*'] + Dir['test/**/*']).grep(/\.rb$/)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.extensions    = ["ext/bin_utils/extconf.rb"]
  gem.name          = "bin_utils"
  gem.require_paths = ["lib", "ext"]

  gem.required_ruby_version = '>= 1.9.1'

  gem.add_development_dependency 'rake-compiler'
  gem.version       = BinUtils::VERSION
end
