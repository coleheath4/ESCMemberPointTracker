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
   
    context 'with an admin account' do
      
      it 'admin will have access to the users page' do
        # make user account
        u = User.new
        u.username = 'usn'
        u.password = 'pass'
        u.email = 'test@email.com'
        u.first_name = 'First'
        u.last_name = 'Last'
        u.is_admin = true
        u.save!
        
        # user signs in
        visit signin_path
        fill_in('username', with: u.username)
        fill_in('password', with: 'pass')
        click_button('Log In')
        
        visit dashboard_path
        sleep(2)
        expect(current_path).to eql users_path
      end

      it 'admin will be redirected to the users page if admin tries to access the dashboard'do
        # make user account
        u = User.new
        u.username = 'usn'
        u.password = 'pass'
        u.email = 'test@email.com'
        u.first_name = 'First'
        u.last_name = 'Last'
        u.is_admin = true
        u.save!
        
        visit signin_path
        fill_in('username', with: u.username)
        fill_in('password', with: 'pass')
        click_button('Log In')

        visit dashboard_path
        sleep(3)
        expect(current_path).to eql users_path
      end

      it 'admin can see a list of users in the organization' do
        # make user account
        admin = User.new
        admin.username = 'usn'
        admin.password = 'pass'
        admin.email = 'test@email.com'
        admin.first_name = 'First'
        admin.last_name = 'Last'
        admin.is_admin = true
        admin.save!
        
        # random non-admin accounts
        u = User.new
        u.username = 'user1'
        u.password = 'pass'
        u.email = 'user1@email.com'
        u.first_name = 'User1'
        u.last_name = 'Last1'
        u.save!
        u = User.new
        u.username = 'user2'
        u.password = 'pass'
        u.email = 'user1@email.com'
        u.first_name = 'User2'
        u.last_name = 'Last2'
        u.save!
        u = User.new
        u.username = 'user3'
        u.password = 'pass'
        u.email = 'user1@email.com'
        u.first_name = 'User3'
        u.last_name = 'Last3'
        u.save!
        
        visit signin_path
        fill_in('username', with: admin.username)
        fill_in('password', with: 'pass')
        click_button('Log In')
        visit users_path
        expect(page).to have_content('User1')
        expect(page).to have_content('User2')
        expect(page).to have_content('User3')
        sleep(5)
      end

      it 'can view a user\'s account info', focus: true do
        # make user account
        admin = User.new
        admin.username = 'usn'
        admin.password = 'pass'
        admin.email = 'test@email.com'
        admin.first_name = 'First'
        admin.last_name = 'Last'
        admin.is_admin = true
        admin.save!
        
        # # random non-admin accounts
        # u = User.new
        # u.username = 'auser1'
        # u.password = 'pass'
        # u.email = 'user1@email.com'
        # u.first_name = 'AUser1'
        # u.last_name = 'Last1'
        # u.save!

        visit signin_path
        fill_in('username', with: admin.username)
        fill_in('password', with: 'pass')
        click_button('Log In')
        visit users_path
        expect(current_path).to eql users_path
        expect(page).to have_content('First Last')
        sleep(2)
        
        # delete account
        # first(page.find('Details')).click
        click_on 'Details'
        sleep(1)
        expect(page).to have_content('Member Details')
        sleep(1)
        click_on 'Delete User'
        sleep(1)
        expect(page).to have_content('Are you sure you want to permanently delete this user?')
      end
      
      # it 'can delete a user in the web app', focus: true do
      #   # make user account
      #   admin = User.new
      #   admin.username = 'usn'
      #   admin.password = 'pass'
      #   admin.email = 'test@email.com'
      #   admin.first_name = 'First'
      #   admin.last_name = 'Last'
      #   admin.is_admin = true
      #   admin.save!
        
      #   # random non-admin accounts
      #   u = User.new
      #   u.username = 'auser1'
      #   u.password = 'pass'
      #   u.email = 'user1@email.com'
      #   u.first_name = 'AUser1'
      #   u.last_name = 'Last1'
      #   u.save!

      #   visit signin_path
      #   fill_in('username', with: admin.username)
      #   fill_in('password', with: 'pass')
      #   click_button('Log In')
      #   visit users_path
      #   expect(current_path).to eql users_path
      #   expect(page).to have_content('User1 Last1')
      #   sleep(2)
        
      #   # delete account
      #   click_button 'Details'
      #   sleep(1)
      #   expect(page).to have_content('Member Details')
      #   sleep(1)
      #   click_button 'Delete User'
      #   sleep(1)
      #   expect(page).to have_content('Are you sure you want to permanently delete this user?')
      #   click_button 'Delete User'
      #   sleep(1)
      #   expect(page).not_to have_content('User1 Last1')
      # end
      
    end

    context 'as a regular user' do
      it 'cannot access the admin-only users page' do
        u = User.new
        u.username = 'usn'
        u.password = 'pass'
        u.email = 'test@email.com'
        u.first_name = 'First'
        u.last_name = 'Last'
        u.save!

        visit signin_path
        fill_in('username', with: u.username)
        fill_in('password', with: 'pass')
        click_button('Log In')
        
        visit users_path
        sleep(3)
        expect(current_path).to eql dashboard_path
      end
    end
  end

  # can't figure out how to test cookies. Tries to use gem 'ShowMeTheCookies' but causing undefined error
  # describe 'session access', focus: true do
  #   context 'user has previously signed in before' do
  #     it 'alllows the user to access their page without requiring to log back in again' do
  #       # make user account
  #       u = User.new
  #       u.username = 'usn'
  #       u.password = 'pass'
  #       u.email = 'test@email.com'
  #       u.first_name = 'First'
  #       u.last_name = 'Last'
  #       u.save!

  #       # user signs in
  #       visit signin_path
  #       fill_in('username', with: u.username)
  #       fill_in('password', with: 'pass')
  #       click_button('Log In')
        
  #       # helper.request.cookies['user_token'] = u.id
  #       visit signin_path
  #       sleep(500)
  #       expect(current_path).to eql dasboard_path
  #       # expect(page).to have_content('Dashboard')
  #       # expect(page).to have_content('First Last')
  #       # expect(page).to have_content('First Last')
  #     end
  #   end
  # end
  
end