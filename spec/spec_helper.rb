# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'rspec/rails/example/widget_example_group'

require 'database_cleaner'
require 'ffaker'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

require 'dotenv'
Dotenv.load

require 'factory_girl'
FactoryGirl.find_definitions

require 'vcr'
VCR.configure do |vcr|
  vcr.ignore_localhost = true
  vcr.cassette_library_dir = 'spec/support/cassettes'
  vcr.hook_into :webmock
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories defined in spree_core
require 'spree/core/testing_support/factories'
require 'spree/core/testing_support/controller_requests'
require 'spree/core/testing_support/authorization_helpers'
require 'spree/core/url_helpers'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # Include WidgetExampleGroup helpers in widget specs
  config.include RSpec::Rails::WidgetExampleGroup,
    example_group: { file_path: %r{spec/widgets} }

  # == URL Helpers
  #
  # Allows access to Spree's routes in specs:
  #
  # visit spree.admin_path
  # current_path.should eql(spree.products_path)
  config.include Spree::Core::UrlHelpers

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  config.color = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.start
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean

    if example.metadata[:js]
      DatabaseCleaner.strategy = :transaction
    end
  end

  def take_screenshot(options = {})
    save_screenshot('./tmp/screenshot.png', options) if respond_to?(:save_screenshot)
  end
end
