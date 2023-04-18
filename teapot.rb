#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

require 'shellwords'

define_target "ruby" do |target|
	target.provides "Library/ruby" do
		append header_search_paths [
			Build::Files::Path.new(RbConfig::CONFIG['rubyarchhdrdir']),
			Build::Files::Path.new(RbConfig::CONFIG['rubyhdrdir']),
		]
		
		ruby_library_directory = ENV.fetch('RUBYLIBDIR') do
			File.expand_path("../lib", target.context.root)
		end
		
		ruby_install_path Build::Files::Path.new(ruby_library_directory)
		
		append linkflags [
			# The dynamic linker flags:
			*Shellwords.split(RbConfig::CONFIG['DLDFLAGS']),
		]
		
		if RUBY_PLATFORM =~ /darwin/
			append linkflags ["-bundle_loader", RbConfig.ruby]
		end
	end
end
