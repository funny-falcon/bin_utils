if RUBY_ENGINE == 'ruby' || RUBY_ENGINE == 'rbx'
  require 'mkmf'
  # rubinius has no rb_str_drop_bytes
  have_func('rb_str_drop_bytes')
  create_makefile("bin_utils")
else
  File.open(File.dirname(__FILE__) + "/Makefile", 'w') do |f|
    f.write("install:\n\t#nothing to build")
  end
end
