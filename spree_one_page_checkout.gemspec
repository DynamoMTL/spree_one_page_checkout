# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_one_page_checkout'
  s.version     = '1.3.3'
  s.summary     = 'A Spree extension to implement a one-page checkout.'
  s.description = """
    This Spree extension replaces the default Spree checkout workflow with a
    streamlined one-page checkout, with reusable address and credit-card
    features.
  """
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Daniel Wright'
  s.email     = 'daniel@godynamo.com'
  s.homepage  = 'http://godynamo.com/'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.3.3'
  s.add_dependency 'apotomo', '~> 1.2.3'
  s.add_dependency 'formtastic', '~> 2.2.1'
  s.add_dependency 'reform', '~> 0.2.0'

  s.add_development_dependency 'capybara', '~> 2.0'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner', '~> 1.0.1'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7.0'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'jazz_hands'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'rspec-apotomo', '~> 0.9.7'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end
