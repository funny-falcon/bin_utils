package bin_utils;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyClass;
import org.jruby.RubyFixnum;
import org.jruby.RubyModule;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.load.BasicLibraryService;

public class BinUtilsService implements BasicLibraryService {
    public boolean basicLoad(Ruby ruby) {
	RubyModule bin_utils = ruby.defineModule("BinUtils");
	RubyModule java_utils = bin_utils.defineModuleUnder("Native");
	java_utils.defineAnnotatedMethods(JavaUtils.class);
	java_utils.extend_object(java_utils);
	return true;
    }
}
