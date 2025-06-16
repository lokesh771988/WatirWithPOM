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
  end

  def error_message
    @browser.p(class: /oxd-alert-content-text/).text
  end

  def logged_in?
    @browser.url.include?('/dashboard')
  end
end 