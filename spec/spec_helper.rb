require 'watir'
require_relative '../pages/login_page'

# Ensure the results directory exists
results_dir = File.expand_path('../results', __dir__)
Dir.mkdir(results_dir) unless Dir.exist?(results_dir)

RSpec.configure do |config|
  config.before(:each) do
    @browser = Watir::Browser.new :chrome
    @login_page = LoginPage.new(@browser)
  end

  config.after(:each) do
    @browser.close
  end

  # Use the built-in HTML formatter
  config.add_formatter('html', File.join(results_dir, 'rspec_results.html'))
end 