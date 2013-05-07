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
include Features::JobOpening
include Features::Candidate

feature 'candidate pages' do
  name = ''
  email = ''
=begin
  background do
    name = 'candidate' + UUIDTools::UUID.random_create
    email = '' + UUIDTools::UUID.random_create + '@letshire.com'
    visit '/'
    sign_in(ADMIN_USERNAME, ADMIN_PASSWORD)
  end

  scenario 'check candidate list layout' do
    add_candidate(name, email, '123456')
    click_link 'Candidates'
    page.should have_content 'Name'
    page.should have_content 'Email'
    page.should have_content 'Phone'
    page.should have_content name
    page.should have_content email
    page.should have_content '123456'
    delete_candidate(name)
  end

  scenario 'add a candidate with job opening assigned' do
    title = 'opening' + UUIDTools::UUID.random_create
    add_job_opening(title, 'Facility')
    add_candidate(name, email, '123456', 'internal referral', 'apply for job', 'Facility', title)
    page.current_path.should =~ /\/candidates\/\d+$/
    page.should have_content title
    page.should have_content name
    page.should have_content email
    page.should have_content '123456'
    page.should have_content 'internal referral'
    page.should have_content 'apply for job'
    delete_candidate(name)
    delete_job_opening(title)
  end

  scenario 'candidate details' do
    title = 'opening' + UUIDTools::UUID.random_create
    add_job_opening(title, 'Facility')
    add_candidate(name, email, '123456', 'internal referral', 'apply for job', 'Facility', title)
    candidate_details(name)
    page.should have_content title
    page.should have_content name
    page.should have_content email
    page.should have_content '123456'
    page.should have_content 'internal referral'
    page.should have_content 'apply for job'
    click_link 'Edit'
    page.current_path.should =~ /\/candidates\/\d+\/edit/
    page.evaluate_script('window.history.back()')
    click_link title
    page.current_path.should =~ /\/openings\/\d+$/
    page.evaluate_script('window.history.back()')
    click_link 'Assign Opening'
    page.current_path.should =~ /\/candidates\/\d+\/new_opening/
    page.evaluate_script('window.history.back()')
    click_link 'Change Status'
    page.current_path.should =~ /\/opening_candidates\/\d+\/assessments\/new/
    page.evaluate_script('window.history.back()')
    click_link 'Add Assessment'
    page.current_path.should =~ /\/opening_candidates\/\d+\/assessments\/new/
    page.evaluate_script('window.history.back()')
    click_link 'New Interview'
    page.current_path.should =~ /\/candidates\/\d+\/interviews\/new/
    delete_candidate(name)
    delete_job_opening(title)
  end

  scenario 'edit a candidate' do
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

  scenario 'delete a candidate' do
    add_candidate(name, email, '123456')
    click_link 'Candidates'
    page.should have_content name
    delete_candidate(name)
    page.current_path.should == '/candidates'
    page.should_not have_content name
  end

  scenario 'validations on adding candidate' do
    click_link 'Candidates'
    find_link('Add a Candidate').click
    click_button 'Save'
    page.should have_content "Name can't be blank"
    page.should have_content "Email can't be blank"
    page.should have_content "Phone can't be blank"
    page.should_not have_content 'Email format error'
    page.should_not have_content 'Phone format error'
    fill_in 'candidate_email', with: 'abc'
    fill_in 'candidate_phone', with: 'abc'
    click_button 'Save'
    page.should_not have_content "Email can't be blank"
    page.should_not have_content "Phone can't be blank"
    page.should have_content 'Email format error'
    page.should have_content 'Phone format error'
  end

  scenario 'Validations on editing candidate' do
    add_candidate(name, email, '123456')
    click_link 'Candidates'
    find(:xpath, "//tr[td[contains(., '#{name}')]]/td/a", :text => 'Edit').click
    fill_in 'candidate_name', with: ''
    fill_in 'candidate_email', with: ''
    fill_in 'candidate_phone', with: ''
    click_button 'Save'
    page.should have_content "Name can't be blank"
    page.should have_content "Email can't be blank"
    page.should have_content "Phone can't be blank"
    fill_in 'candidate_email', with: 'abc'
    fill_in 'candidate_phone', with: 'abc'
    click_button 'Save'
    page.should_not have_content "Email can't be blank"
    page.should_not have_content "Phone can't be blank"
    page.should have_content 'Email format error'
    page.should have_content 'Phone format error'
    click_link 'Candidates'
    delete_candidate(name)
  end
=end
end
