$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'conduit-rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  # Details
  #
  s.name     = 'conduit-rails'
  s.version  = ConduitRails::VERSION
  s.authors  = ['Mike Kelley']
  s.email    = ['mike@codezombie.org']
  s.homepage = 'https://github.com/conduit/conduit-rails'
  s.summary  = 'Conduit is an interface for debit platforms.'

  # Files
  #
  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*', 'lib/conduit/drivers/**/spec/*']

  # Dependencies
  #
  s.add_dependency 'conduit', '~> 1.1'
  s.add_dependency 'request_store', '~> 1'
  s.add_dependency 'rails', '~> 4.2'

  # Development Dependencies
  #
  s.add_development_dependency 'shoulda-matchers', '~> 2.6'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'pg'

end
