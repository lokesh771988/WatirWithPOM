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
    expect(@login_page.error_message).to include('Invalid credentials')
  end
end 