
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yajl-rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'yajl-rest'
  spec.version       = YajlRest::VERSION
  spec.authors       = ['Michael Klimenko']
  spec.email         = ['m@klimenko.site']

  spec.summary       = 'Streaming JSON arrays parser for Ruby'
  spec.description   = ''
  spec.homepage      = 'https://github.com/michaelkl/yajl-rest'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = Dir['lib/**/*.rb'] + Dir["bin/*"]
  spec.files        += Dir["[A-Z]*"] + Dir["spec/**/*"]
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client', ['>= 1.8.0', '< 2.1']
  spec.add_dependency 'yajl-ffi', '>= 0.1'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  #spec.add_development_dependency 'rspec', '~> 3.0'

  spec.required_ruby_version = '>= 2.0.0'
end
