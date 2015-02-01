# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

def setup_test_fixture
  @user = User.new(email: "example@example.com", password: "example")
end

def default_form
  "<form role=\"form\" class=\"new_user\" id=\"new_user\" action=\"/users\" accept-charset=\"UTF-8\" method=\"post\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" />#{yield if block_given?}</form>"
end

def horizontal_form
  "<form role=\"form\" class=\"form-horizontal\" id=\"new_user\" action=\"/users\" accept-charset=\"UTF-8\" method=\"post\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" />#{yield if block_given?}</form>"
end

def inline_form
  "<form role=\"form\" class=\"form-inline\" id=\"new_user\" action=\"/users\" accept-charset=\"UTF-8\" method=\"post\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" />#{yield if block_given?}</form>"
end