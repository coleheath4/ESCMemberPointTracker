require 'rails_helper'

RSpec.describe 'ESC Point Tracker', type: :system do
  describe 'sign in page' do
    it 'shows the right content' do
      visit signin_path
      expect(page.body).to have_content('Sign in')
      sleep(5)
    end
  end

  describe 'register a user' do
    it 'registers a new user' do
        visit signin_path
        click_link('Register')
        fill_in('username', :with => 'myUsername')
        fill_in('password', :with => 'myPassword')
        fill_in('password_confirm', :with => 'myPassword')
        fill_in('user_email', :with => 'myemail@email.com')
        fill_in('user_first_name', :with => 'myFirst')
        fill_in('user_last_name', :with => 'myLast')
        sleep(5)
        click_button('Register')
        expect(page.body).to have_content('Dashboard')
        sleep(5)
    end
  end

  describe 'login' do
    it 'existing user can log in' do
        visit signin_path
        click_link('Register')
        fill_in('username', :with => 'myUsername')
        fill_in('password', :with => 'myPassword')
        fill_in('password_confirm', :with => 'myPassword')
        fill_in('user_email', :with => 'myemail@email.com')
        fill_in('user_first_name', :with => 'myFirst')
        fill_in('user_last_name', :with => 'myLast')
        click_button('Register')
        click_link('Logout')
        fill_in('username', :with => 'myUsername')
        fill_in('password', :with => 'myPassword')
        click_button('Log In')
        expect(page.body).to have_content('Dashboard')
        sleep(5)
    end
  end

  describe 'login w/o account info' do
    it 'malicious user cannot login without an account' do
        visit signin_path
        click_button('Log In')
        expect(page.body).to have_content('Sign in')
        sleep(5)
        click_button('Log In')
        expect(page.body).to have_content('Sign in')
        sleep(5)
    end
  end

  describe 'admin access' do
    it 'user cannot view admin page as non-admin' do
        visit signin_path
        click_link('Register')
        fill_in('username', :with => 'myUsername')
        fill_in('password', :with => 'myPassword')
        fill_in('password_confirm', :with => 'myPassword')
        fill_in('user_email', :with => 'myemail@email.com')
        fill_in('user_first_name', :with => 'myFirst')
        fill_in('user_last_name', :with => 'myLast')
        click_button('Register')
        click_link('Logout')
        fill_in('username', :with => 'myUsername')
        fill_in('password', :with => 'myPassword')
        click_button('Log In')
        visit users_path
        expect(page.body).to have_content('Dashboard')
        sleep(5)
    end
  end
end