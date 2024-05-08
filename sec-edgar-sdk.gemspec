require_relative 'lib/sec-edgar/version'

Gem::Specification.new do |s|
  s.name        = 'sec-edgar-sdk'
  s.version     = SecEdgar::VERSION
  s.summary     = 'SEC EDGAR SDK'
  s.description = 'A Ruby SDK for the SEC EDGAR API'
  s.authors     = ['David Christensen']
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/david-christensen/sec-edgar-sdk'
  s.license     = 'MIT'
  s.add_dependency 'httparty', '~> 0.22.0'
  s.add_dependency 'activesupport', '~> 7.1', '>= 7.1.3.2'
  s.add_dependency 'nokogiri', '~> 1.15', '>= 1.15.4'
end
