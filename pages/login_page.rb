class LoginPage
  def initialize(browser)
    @browser = browser
  end

  def visit
    @browser.goto 'https://opensource-demo.orangehrmlive.com/web/index.php/auth/login'
  end

  def login(username, password)
    @browser.text_field(name: 'username').set(username)
    @browser.text_field(name: 'password').set(password)
    @browser.button(type: 'submit').click
    # Wait a bit for error message to appear
    sleep(2)
  end

  def error_message
    @browser.p(class: /oxd-alert-content-text/).text
  end

  # New method to return the actual error element for screenshots
  def error_element
    @browser.p(class: /oxd-alert-content-text/)
  end

  # Check if error element exists
  def error_present?
    begin
      @browser.p(class: /oxd-alert-content-text/).present?
    rescue
      false
    end
  end

  # Simple method to take screenshot of the error element
  def take_error_screenshot(filename = nil)
    begin
      # Get the error element directly
      error_elem = @browser.p(class: /oxd-alert-content-text/)
      
      if error_elem.present?
        # Create filename
        timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
        filename ||= "error_screenshot_#{timestamp}.png"
        
        # Save to results directory - element only screenshot
        element_screenshot_path = File.join('results', filename)
        
        # Use the same method as the working alt version
        error_elem.screenshot(element_screenshot_path)
        puts "Element screenshot saved: #{element_screenshot_path}"
        
        return element_screenshot_path
      else
        puts "Error element not visible"
        return nil
      end
    rescue => e
      puts "Error taking screenshot: #{e.message}"
      puts "Falling back to full page screenshot..."
      
      # Fallback to full page screenshot if element screenshot fails
      begin
        timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
        fallback_filename = filename || "error_fallback_#{timestamp}.png"
        fallback_path = File.join('results', fallback_filename)
        
        @browser.screenshot.save(fallback_path)
        puts "Fallback screenshot saved: #{fallback_path}"
        return fallback_path
      rescue => fallback_error
        puts "Fallback screenshot also failed: #{fallback_error.message}"
        return nil
      end
    end
  end

  def logged_in?
    @browser.url.include?('/dashboard')
  end



  # Generic method to take screenshot of any element using WebDriver
  def take_element_screenshot_webdriver(element, filename = nil)
    begin
      if element.present?
        # Create filename
        timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
        filename ||= "element_webdriver_#{timestamp}.png"
        
        # Save to results directory
        element_screenshot_path = File.join('results', filename)
        
        # Use WebDriver's element screenshot method directly
        webdriver_element = element.wd
        screenshot_data = webdriver_element.screenshot_as(:png)
        
        # Write the screenshot data to file
        File.open(element_screenshot_path, 'wb') do |file|
          file.write(screenshot_data)
        end
        
        puts "WebDriver element screenshot saved: #{element_screenshot_path}"
        return element_screenshot_path
        
      else
        puts "Element not visible"
        return nil
      end
    rescue => e
      puts "Error with WebDriver screenshot: #{e.message}"
      return nil
    end
  end

  # Generic method to take screenshot of any element using coordinates and cropping
  def take_element_screenshot_cropped(element, filename = nil)
    begin
      if element.present?
        # Create filename
        timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
        filename ||= "element_cropped_#{timestamp}.png"
        
        # Get element location and size
        location = element.location
        size = element.size
        
        puts "Element location: #{location}"
        puts "Element size: #{size}"
        
        # Take full page screenshot first
        temp_screenshot_path = File.join('results', "temp_full_#{timestamp}.png")
        @browser.screenshot.save(temp_screenshot_path)
        
        # Crop the screenshot to element area using ChunkyPNG
        require 'chunky_png'
        
        # Read the full screenshot
        full_image = ChunkyPNG::Image.from_file(temp_screenshot_path)
        
        # Calculate crop coordinates
        x = location['x'].to_i
        y = location['y'].to_i
        width = size['width'].to_i
        height = size['height'].to_i
        
        # Add some padding around the element
        padding = 10
        x = [x - padding, 0].max
        y = [y - padding, 0].max
        width = width + (padding * 2)
        height = height + (padding * 2)
        
        # Ensure we don't exceed image boundaries
        width = [width, full_image.width - x].min
        height = [height, full_image.height - y].min
        
        puts "Cropping coordinates: x=#{x}, y=#{y}, width=#{width}, height=#{height}"
        
        # Crop the image
        cropped_image = full_image.crop(x, y, width, height)
        
        # Save the cropped image
        element_screenshot_path = File.join('results', filename)
        cropped_image.save(element_screenshot_path)
        
        # Clean up temp file
        File.delete(temp_screenshot_path) if File.exist?(temp_screenshot_path)
        
        puts "Element-only screenshot saved: #{element_screenshot_path}"
        return element_screenshot_path
        
      else
        puts "Element not visible"
        return nil
      end
    rescue => e
      puts "Error taking element-only screenshot: #{e.message}"
      return nil
    end
  end

  # Specific method for error element (uses generic method)
  def take_error_screenshot_webdriver(filename = nil)
    error_elem = @browser.p(class: /oxd-alert-content-text/)
    take_element_screenshot_webdriver(error_elem, filename)
  end

  # Specific method for error element using cropping (uses generic method)
  def take_element_only_screenshot(filename = nil)
    error_elem = @browser.p(class: /oxd-alert-content-text/)
    take_element_screenshot_cropped(error_elem, filename)
  end
end 