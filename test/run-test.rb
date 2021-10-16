#!/usr/bin/env ruby

$VERBOSE = true

base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir = File.join(base_dir, "lib")
test_dir = File.join(base_dir, "test")

$LOAD_PATH.unshift(lib_dir)

case ENV["RR_INTEGRATION"]
when "minitest"
  require "minitest"
  require "rr"
when "minitest-active-support"
  require "active_support/test_case"
  require "rr"
end

require "test-unit"
require "test/unit/rr"

exit(Test::Unit::AutoRunner.run(true, test_dir))
