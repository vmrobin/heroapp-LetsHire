#require 'spec_helper'
require 'capybara/rspec'
require 'capybara'
require 'capybara/dsl'
require 'uuidtools'
require_relative '../support/features/ui_helper'

Capybara.run_server = true
Capybara.default_driver = :selenium
Capybara.app_host = 'http://letshire-qa.cloudfoundry.com'

include Features
include Features::SignIn
include Features::User

feature 'user pages' do
  name = ''
  email = ''

  background do
    name = 'user' + UUIDTools::UUID.random_create
    email = '' + UUIDTools::UUID.random_create + '@letshire.com'
    visit '/'
    sign_in(ADMIN_USERNAME, ADMIN_PASSWORD)
  end
=begin
  scenario 'check user list layout' do
    add_user(name, email, '12345678')
    click_link 'Users + Roles'
    page.should have_content 'Name'
    page.should have_content 'Email'
    page.should have_content name
    page.should have_content email
    delete_user(name)
  end

  scenario 'add a user' do
    add_user(name, email, '12345678', 'Facility', ['Interviewer', 'Recruiter', 'Hiring manager'])
    page.current_path.should =~ /\/users\/\d+$/
    page.should have_content name
    page.should have_content email
    page.should have_content '12345678'
    page.should have_content 'Facility'
    page.should have_content 'Interviewer'
    page.should have_content 'Recruiter'
    page.should have_content 'Hiring Manager'
    delete_user(name)
  end

  scenario 'user details' do
    add_user(name, email, '12345678', 'Facility', ['Interviewer', 'Recruiter', 'Hiring manager'])
    user_details(name)
    find(:xpath, "//input[@id='user_email']").value.should == email
    find(:xpath, "//input[@id='user_department_string']").value.should == 'Facility'
    page.should have_content name
    #page.should have_content email
    #page.should have_content 'Facility'
    #page.should have_content 'Interviewer'
    #page.should have_content 'Recruiter'
    #page.should have_content 'Hiring Manager'
    delete_user(name)
  end

  scenario 'edit a user' do
    add_candidate('slayer', 'abc@sc.com', '123456')
    edit_candidate('slayer', name, email, '234567', 'internal referral', 'apply for job')
    page.current_path.should =~ /\/candidates\/\d+$/
    page.should have_content name
    page.should have_content email
    page.should have_content '234567'
    page.should have_content 'internal referral'
    page.should have_content 'apply for job'
    delete_candidate(name)
  end

  scenario 'delete a user' do
    add_user(name, email, '12345678')
    click_link 'Users + Roles'
    page.should have_content name
    delete_user(name)
    page.current_path.should == '/users'
    page.should_not have_content name
  end

  scenario 'validations on adding user' do
    click_link 'Users + Roles'
    find_link('Add a User').click
    click_button 'Save'
    page.should have_content "Name can't be blank"
    page.should have_content "Email can't be blank"
    page.should have_content "Password can't be blank"
    fill_in 'user_email', with: 'abc'
    fill_in 'user_password', with: '1234567'
    click_button 'Save'
    page.should have_content "Password doesn't match confirmation"
    page.should have_content 'Password is too short (minimum is 8 characters)'
  end
=end
  scenario 'Validations on editing user' do
    add_user(name, email, '12345678')
    click_link 'Users + Roles'
    find(:xpath, "//tr[td[contains(., '#{name}')]]/td/a", :text => 'Edit').click
    fill_in 'user_name', with: ''
    fill_in 'user_email', with: ''
    fill_in 'user_password', with: ''
    click_button 'Save'
    page.should have_content "Name can't be blank"
    page.should have_content "Email can't be blank"
    #page.should_not have_content "Password can't be blank"
    fill_in 'user_password', with: 'a'
    click_button 'Save'
    page.should have_content "Password doesn't match confirmation"
    page.should have_content 'Password is too short (minimum is 8 characters)'
    click_link 'Users + Roles'
    delete_user(name)
  end

end
