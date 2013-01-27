require "bin_utils/version"

module BinUtils
  begin
    if RUBY_ENGINE == 'jruby'
      require 'bin_utils/bin_utils.jar'
    else
      require 'bin_utils/bin_utils'
    end
    extend ::BinUtils::Native
  rescue LoadError
    raise
    require 'bin_utils/pure_ruby'
    extend PureRuby
    if RUBY_ENGINE == 'ruby' || RUBY_ENGINE == 'jruby'
      $stderr.puts "Attention: pure ruby version of BinUtils is used"
    end
  end
end
