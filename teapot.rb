#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

require 'shellwords'

define_target "ruby" do |target|
	target.provides "Platform/ruby" do
		append header_search_paths [
			Build::Files::Path.new(RbConfig::CONFIG['rubyarchhdrdir']),
			Build::Files::Path.new(RbConfig::CONFIG['rubyhdrdir']),
		]
		
		ruby_library_directory = ENV.fetch('RUBYLIBDIR') do
			File.expand_path("../lib", __dir__)
		end
		
		ruby_install_path Build::Files::Path.new(ruby_library_directory)
		
		append linkflags [
			# The library directory where ruby is installed:
			"-L#{RbConfig::CONFIG['libdir']}",
			
			# The dynamic linker flags:
			*Shellwords.split(RbConfig::CONFIG['DLDFLAGS']),
			
			# The libraries required to link against ruby:
			*Shellwords.split(RbConfig::CONFIG['LIBRUBYARG']),
		]
	end
end
