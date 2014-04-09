if RUBY_PLATFORM == 'java'
  File.open('Makefile', 'w') { |f| f.puts("install:\n\t$(echo Skipping native extensions)") }
else
  require 'mkmf'
  create_makefile('nested_multimap_ext')
end
