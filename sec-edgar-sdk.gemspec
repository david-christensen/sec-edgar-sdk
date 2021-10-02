Gem::Specification.new do |s|
  s.name        = 'sec-edgar-sdk'
  s.version     = '0.0.0'
  s.summary     = 'SEC EDGAR SDK'
  s.description = 'A Ruby SDK for the SEC EDGAR API'
  s.authors     = ['David Christensen']
  s.files       = Dir['lib/**/*.rb']
  s.homepage    =
    'https://github.com/david-christensen/sec-edgar-edgar-sdk'
  s.license       = 'MIT'
  s.add_dependency 'httparty', '~> 0.19', '>= 0.19.0'
  s.add_dependency 'activesupport', '~> 6.1', '>= 6.1.4.1'
end
