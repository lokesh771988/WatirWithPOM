require 'spec_helper'

describe 'OrangeHRM Login' do
  it 'logs in with valid credentials' do
    @login_page.visit
    @login_page.login('Admin', 'admin123')
    expect(@login_page.logged_in?).to be true
  end

  it 'shows error with invalid credentials' do
    @login_page.visit
    @login_page.login('invalid', 'invalid')
    
    # Check if error element is present
    puts "Error present: #{@login_page.error_present?}"
    
    if @login_page.error_present?
      puts "Error message text: #{@login_page.error_message}"
      
      # Try WebDriver element screenshot method (most reliable)
      puts "Trying WebDriver element screenshot method..."
      result1 = @login_page.take_error_screenshot_webdriver('webdriver_error.png')

      result2 = @login_page.take_element_screenshot_webdriver(@login_page.error_element, 'webdriver_error1.png')
      
      # Try cropping method
      #puts "Trying element-only cropping method..."
      #result2 = @login_page.take_element_only_screenshot('cropped_error.png')
      
      # Try original method for comparison
      #puts "Trying original method for comparison..."
      #result3 = @login_page.take_error_screenshot('original_error.png')
      
      puts "WebDriver method result: #{result1}"
      puts "Cropping method result: #{result2}"
      #puts "Original method result: #{result3}"
    end
    
    expect(@login_page.error_message).to include('Invalid credentials')
  end

end 