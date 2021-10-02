Gem::Specification.new do |s|
  s.name        = 'sec-edgar-edgar-sdk'
  s.version     = '0.0.0'
  s.summary     = 'SEC EDGAR SDK'
  s.description = 'A Ruby SDK for the SEC EDGAR API'
  s.authors     = ['David Christensen']
  s.files       = ['lib']
  s.homepage    =
    'https://github.com/david-christensen/sec-edgar-edgar-sdk'
  s.license       = 'MIT'
  s.add_dependency 'httparty'
  s.add_dependency 'activesupport'
end
