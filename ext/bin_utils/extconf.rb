begin
  unless RUBY_ENGINE == 'ruby' || RUBY_ENGINE == 'rbx'
    raise "Uh"
  end
  require 'mkmf'
  # rubinius has no rb_str_drop_bytes
  have_func('rb_str_drop_bytes')
  create_makefile("bin_utils")
rescue
  File.open(File.dirname(__FILE__) + "/Makefile", 'w') do |f|
    f.write("install:\n\t#nothing to build")
  end
end
