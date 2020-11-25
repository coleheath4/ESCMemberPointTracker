# README
This is the ESC Member Point Tracker.

This repo has three branches:

-master
-test
-dev

This app uses Heroku pipelines. 

# CODE EXECUTION
$rails server

This will host and run the application on local host

# DEPLOY TO HEROKU
$heroku login

$git push heroku master

This will push the latest code on master to heroku deployment

# RUNNING SECURITY TESTS
$rspec spec/sign_in_spec.rb

Utilized Capybara testing framework to write security tests

Combined both unit and integration tests

Tests look at:
- Login attemps
- Accessing hidden pages and actions for non-admins
- XSS
- Providing incorrect field info into input forms

# CI/CD
Not implemented
