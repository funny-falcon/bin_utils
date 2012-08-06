require "bin_utils/version"

module BinUtils
  begin
    require 'bin_utils/native_bin_utils'
    extend Native
  rescue LoadError
    require 'bin_utils/pure_ruby'
    extend PureRuby
    if RUBY_ENGINE == 'ruby'
      $stderr.puts "Attention: pure ruby version of BinUtils is used"
    end
  end
end
