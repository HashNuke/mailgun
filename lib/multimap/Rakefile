require 'rubygems/specification'
spec = eval(File.read('multimap.gemspec'))

if spec.has_rdoc
  require 'rake/rdoctask'

  Rake::RDocTask.new { |rdoc|
    rdoc.options = spec.rdoc_options
    rdoc.rdoc_files = spec.files
  }
end


task :default => :spec

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.warning = true
end


begin
  require 'rake/extensiontask'

  Rake::ExtensionTask.new do |ext|
    ext.name = 'nested_multimap_ext'
    ext.gem_spec = $spec
  end

  desc "Run specs using C ext"
  task "spec:ext" => [:compile, :spec, :clobber]
rescue LoadError
end
