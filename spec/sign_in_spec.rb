# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ESC Point Tracker', type: :system do
  describe 'sign in page' do
    it 'shows the right content' do
      visit signin_path
      expect(page.body).to have_content("Don't have an account?")
      sleep(5)
    end
  end

  describe 'register a user' do
    it 'registers a new user', signin: true do
      visit signin_path
      click_link('Register')
      fill_in('username', with: 'myUsername')
      fill_in('password', with: 'myPassword1')
      fill_in('password_confirm', with: 'myPassword1')
      fill_in('user_email', with: 'myemail@email.com')
      fill_in('user_first_name', with: 'myFirst')
      fill_in('user_last_name', with: 'myLast')
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
      fill_in('username', with: 'myUsername')
      fill_in('password', with: 'myPassword1')
      fill_in('password_confirm', with: 'myPassword1')
      fill_in('user_email', with: 'myemail@email.com')
      fill_in('user_first_name', with: 'myFirst')
      fill_in('user_last_name', with: 'myLast')
      click_button('Register')
      click_link('Logout')
      fill_in('username', with: 'myUsername')
      fill_in('password', with: 'myPassword1')
      click_button('Log In')
      expect(page.body).to have_content('Dashboard')
      sleep(5)
    end
  end

  describe 'login w/o account info' do
    it 'malicious user cannot login without an account' do
      visit signin_path
      click_button('Log In')
      expect(page.body).to have_content("Don't have an account?")
      sleep(5)
      click_button('Log In')
      expect(page.body).to have_content("Don't have an account?")
      sleep(5)
    end
  end

  describe 'admin access' do
    it 'user cannot view admin page as non-admin' do
      visit signin_path
      click_link('Register')
      fill_in('username', with: 'myUsername')
      fill_in('password', with: 'myPassword1')
      fill_in('password_confirm', with: 'myPassword1')
      fill_in('user_email', with: 'myemail@email.com')
      fill_in('user_first_name', with: 'myFirst')
      fill_in('user_last_name', with: 'myLast')
      click_button('Register')
      click_link('Logout')
      fill_in('username', with: 'myUsername')
      fill_in('password', with: 'myPassword1')
      click_button('Log In')
      visit users_path
      expect(page.body).to have_content('Dashboard')
      sleep(5)
    end

    context 'with an admin account' do
      it 'admin will have access to the users page' do
        # make user account
        u = create_default_admin_account

        # user signs in
        visit signin_path
        fill_in('username', with: u.username)
        fill_in('password', with: 'pass')
        click_button('Log In')

        visit dashboard_path
        click_link('Users')
        sleep(2)
        expect(current_path).to eql users_path
      end

      it 'admin will be redirected to the dashboard page if admin tries to access the dashboard' do
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
        expect(current_path).to eql dashboard_path
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

      it 'can view a user\'s account info' do
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

      it 'can delete a user in the web app', focus: true do
        # random non-admin accounts
        u = User.new
        u.username = 'auser1'
        u.password = 'pass'
        u.email = 'user1@email.com'
        u.first_name = 'AUser1'
        u.last_name = 'Last1'
        u.save!

        # make user account
        admin = User.new
        admin.username = 'usn'
        admin.password = 'pass'
        admin.email = 'test@email.com'
        admin.first_name = 'First'
        admin.last_name = 'Last'
        admin.is_admin = true
        admin.save!

        visit signin_path
        fill_in('username', with: admin.username)
        fill_in('password', with: 'pass')
        click_button('Log In')
        visit users_path
        expect(current_path).to eql users_path
        expect(page).to have_content('AUser1 Last1')

        # delete account
        first(:link, 'Details').click
        expect(page).to have_content('Member Details')
        click_link 'Delete User'
        expect(page).to have_content('Are you sure you want to permanently delete this user?')
        click_button 'Delete User'
        sleep(3)
        expect(page).not_to have_content('AUser1 Last1')
      end
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

  describe 'Rewards page' do
    context 'when there is a reward' do
      it 'can go to the rewards page' do
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

        visit rewards_path
        sleep(1)
        expect(page).to have_content('Upcoming Rewards')
      end
    end

    context 'as an admin', focus: true do
      it 'has the button to add a reward' do
        admin = create_default_admin_account
        sign_in(admin)
        visit rewards_path
        sleep(1)
        expect(find_button('Add Reward')).to have_text('Add Reward')
        sleep(3)
      end

      it 'can add events/rewards', focus: true do
        admin = User.new
        admin.username = 'usn'
        admin.password = 'pass'
        admin.email = 'test@email.com'
        admin.first_name = 'First'
        admin.last_name = 'Last'
        admin.is_admin = true
        admin.save!

        visit signin_path
        fill_in('username', with: admin.username)
        fill_in('password', with: 'pass')
        click_button('Log In')

        visit rewards_path
        expect(page).to have_content('Rewards')
        click_button 'Add Reward'

        expect(page).to have_content('Create New Reward')
        fill_in('reward_name', with: 'Event 2')
        fill_in('reward_description', with: 'Event Desc')
        fill_in('reward_points_required', with: '5')
        fill_in('reward_when', with: '04-20-2021004:20AM')
        sleep(3)
        click_button 'Create Event'
        expect(page).to have_content('Event 2')
        sleep(5)
      end

      it 'can edit event/reward details', focus: true do
        reward1 = Reward.new
        reward1.name = 'Event 1'
        reward1.description = 'Event 1 desc'
        reward1.points_required = 5
        reward1.when = '2021-01-08T04:05:06'
        reward1.save!

        reward2 = Reward.new
        reward2.name = 'Event 2'
        reward2.description = 'Event 2 desc'
        reward2.points_required = 5
        reward2.when = '2021-04-21T04:05:06'
        reward2.save!

        reward3 = Reward.new
        reward3.name = 'Event 3'
        reward3.description = 'Event 3 desc'
        reward3.points_required = 5
        reward3.when = '2021-01-13T04:05:06'
        reward3.save!

        admin = User.new
        admin.username = 'usn'
        admin.password = 'pass'
        admin.email = 'test@email.com'
        admin.first_name = 'First'
        admin.last_name = 'Last'
        admin.is_admin = true
        admin.save!

        visit signin_path
        fill_in('username', with: admin.username)
        fill_in('password', with: 'pass')
        click_button('Log In')

        visit rewards_path

        first(:link, 'Details').click

        click_link 'Edit'

        fill_in('reward_description', with: 'New event desc')
        fill_in('reward_points_required', with: '7')

        click_button 'Update Event'

        visit rewards_path

        expect(page).to have_content('New event desc')

        sleep(3)
      end

      it 'can delete events/rewards', focus: true do
        reward1 = Reward.new
        reward1.name = 'Event 1'
        reward1.description = 'Event 1 desc'
        reward1.points_required = 5
        reward1.when = '2021-01-08T04:05:06'
        reward1.save!

        reward2 = Reward.new
        reward2.name = 'Event 2'
        reward2.description = 'Event 2 desc'
        reward2.points_required = 5
        reward2.when = '2021-04-21T04:05:06'
        reward2.save!

        reward3 = Reward.new
        reward3.name = 'Event 3'
        reward3.description = 'Event 3 desc'
        reward3.points_required = 5
        reward3.when = '2021-01-13T04:05:06'
        reward3.save!

        admin = User.new
        admin.username = 'usn'
        admin.password = 'pass'
        admin.email = 'test@email.com'
        admin.first_name = 'First'
        admin.last_name = 'Last'
        admin.is_admin = true
        admin.save!

        visit signin_path
        fill_in('username', with: admin.username)
        fill_in('password', with: 'pass')
        click_button('Log In')

        visit rewards_path

        first(:link, 'Details').click

        click_link 'Delete'

        expect(page).to have_content('Are you sure you want to permanently delete the reward?')

        click_button 'Delete Reward'

        expect(page).to have_content('Reward Event 1 destroyed successfully')

        sleep(3)
      end
    end

    context 'as a regular user', focus: false do
      it 'cannot have access to the add rewards button' do
        u = create_default_user_account
        sign_in(u)

        sleep(1)
        visit rewards_path
        expect(page).not_to have_content('Add Reward')

        sleep(3)
      end

      it 'can see the number of points I have in the rewards page' do
        u = create_default_user_account
        u.points = 30
        u.save!
        sign_in(u)

        visit rewards_path
        expect(page).to have_text('Points: 30')
      end

      it 'can see the percentage I am about to complete for a reward' do
        u = create_default_user_account
        u.points = 10
        u.save!
        sign_in(u)

        reward = Reward.new
        reward.name = 'Test Reward'
        reward.description = 'This is the description'
        reward.points_required = 20
        reward.when = Time.now + 3.months
        reward.save!

        visit rewards_path
        expect(page).to have_content('Test Reward')
        expect(page).to have_text('50 %')
      end

      it 'can navigate to rewards from different pages' do
        u = create_default_user_account
        sign_in(u)

        visit dashboard_path
        click_on 'Rewards'
        expect(current_path).to eql rewards_path

        visit rewards_path
        click_on 'Rewards'
        expect(current_path).to eql rewards_path
      end

      it 'cannot access the page to create new rewards', hello: true do
        u = create_default_user_account
        sign_in(u)

        visit new_reward_path
        expect(current_path).not_to eql new_reward_path
        sleep(5)
      end

      it 'cannot access the page to edit rewards', hello: true do
        reward = Reward.new
        reward.name = 'Test Reward'
        reward.description = 'This is the description'
        reward.points_required = 20
        reward.when = Time.now + 3.months
        reward.save!

        u = create_default_user_account
        sign_in(u)

        visit edit_reward_path(reward)
        expect(current_path).not_to eql edit_reward_path(reward)
        sleep(5)
      end

      it 'cannot access the page to delete rewards', hello: true do
        reward = Reward.new
        reward.name = 'Test Reward'
        reward.description = 'This is the description'
        reward.points_required = 20
        reward.when = Time.now + 3.months
        reward.save!

        u = create_default_user_account
        sign_in(u)

        visit delete_reward_path(reward)
        expect(current_path).not_to eql delete_reward_path(reward)
        sleep(5)
      end
    end
  end
end

def sign_in(account)
  visit signin_path
  fill_in('username', with: account.username)
  fill_in('password', with: 'pass')
  click_button('Log In')
end

def log_out
  visit logout_path
end

def create_default_user_account
  u = User.new
  u.username = 'usn'
  u.password = 'pass'
  u.email = 'test@email.com'
  u.first_name = 'First'
  u.last_name = 'Last'
  u.save!
  u
end

def create_default_admin_account
  u = User.new
  u.username = 'admin'
  u.password = 'pass'
  u.email = 'admin@esc.com'
  u.first_name = 'Admin'
  u.last_name = 'Istrator'
  u.is_admin = true
  u.save!
  u
end
