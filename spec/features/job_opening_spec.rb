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

feature 'job opening pages' do
  title = ''
  background do
    title = 'opening' + UUIDTools::UUID.random_create
    visit '/'
    sign_in(RECRUITER_USERNAME, RECRUITER_PASSWORD)
  end

  scenario 'check job opening list layout' do
    add_job_opening(title, 'Customer Support', true, 3, 'recruiting hiring manager 1')
    click_link 'Job Openings'
    page.should have_content 'Title'
    page.should have_content 'Department'
    page.should have_content 'Hiring Manager'
    page.should have_content 'Status'
    page.should have_content 'Filled/Total'
    page.should have_content '# of Candidates'
    page.should have_content title
    page.should have_content 'Customer Support'
    page.should have_content 'recruiting hiring manager 1'
    page.should have_content 'published'
    page.should have_content '0/3'
    click_link 'View All'
    page.should_not have_link 'View All'
    click_link 'View Mine'
    page.should_not have_link 'View Mine'
    page.should have_link 'View All'
    delete_job_opening(title)
  end

  scenario 'add a draft job opening' do
    add_job_opening(title, 'Customer Support', false, 3, 'recruiting hiring manager 1',
      'recruiter1', 'China', 'Shanghai', 'CityofSH')
    page.should have_content title
    page.should have_content 'recruiter1'
    page.should have_content 'recruiting hiring manager 1'
    page.should have_content 'China'
    page.should have_content 'Shanghai'
    page.should have_content 'CityofSH'
    page.should have_content 'draft'
    delete_job_opening(title)
  end

  scenario 'add a published job opening' do
    add_job_opening(title, 'Customer Support', true, 4, 'recruiting hiring manager 1',
      'recruiter1', 'United States', 'New York', 'NYCity')
    page.should have_content title
    page.should have_content 'recruiting hiring manager 1'
    page.should have_content 'recruiter1'
    page.should have_content 'United States'
    page.should have_content 'New York'
    page.should have_content 'NYCity'
    page.should have_content 'published'
    delete_job_opening(title)
  end

  scenario 'job opening details' do
    add_job_opening(title, 'Customer Support', false, 3, 'recruiting hiring manager 1',
      'recruiter1', 'China', 'Shanghai', 'CityofSH', 'join vmware!')
    job_opening_details(title)
    page.should have_content title
    page.should have_content 'recruiter1'
    page.should have_content 'recruiting hiring manager 1'
    page.should have_content 'China'
    page.should have_content 'Shanghai'
    page.should have_content 'CityofSH'
    page.should have_content 'draft'
    page.should have_content 'join vmware'
    delete_job_opening(title)
  end

  scenario 'edit a draft job opening' do
    currentTitle = 'opening' + UUIDTools::UUID.random_create
    newTitle = 'opening' + UUIDTools::UUID.random_create
    add_job_opening(currentTitle, 'Customer Support', false, 3, 'recruiting hiring manager 1', 'recruiter1')
    edit_job_opening(currentTitle, newTitle, 'published', 'Customer Support', 23, 'recruiting hiring manager 1',
      'recruiter1', 'China', 'Shanghai', 'cityofsh', 'editjobopening')
    page.should have_content newTitle
    page.should have_content 'recruiting hiring manager 1'
    page.should have_content 'recruiter1'
    page.should have_content '23'
    page.should have_content 'China'
    page.should have_content 'Shanghai'
    page.should have_content 'cityofsh'
    page.should have_content 'published'
    page.should have_content 'editjobopening'
    delete_job_opening(newTitle)
  end

  scenario 'edit a published job opening' do
    currentTitle = 'opening' + UUIDTools::UUID.random_create
    newTitle = 'opening' + UUIDTools::UUID.random_create
    add_job_opening(currentTitle, 'Customer Support', true, 2, 'recruiting hiring manager 1', 'recruiter1')
    edit_job_opening(currentTitle, newTitle, 'closed', 'Customer Support', 10, '', '', 'United States',
      'New York', 'cityofny', 'editjobopening', 'System Administrator')
    page.should have_content newTitle
    page.should have_content '10'
    page.should have_content 'System Administrator'
    page.should have_content 'recruiting hiring manager 1'
    page.should have_content 'recruiter1'
    page.should have_content 'United States'
    page.should have_content 'New York'
    page.should have_content 'cityofny'
    page.should have_content 'closed'
    page.should have_content 'editjobopening'
    delete_job_opening(newTitle)
  end

  scenario 'delete a job opening' do
    add_job_opening(title, 'Customer Support')
    click_link 'Job Openings'
    page.should have_content title
    delete_job_opening(title)
    page.should_not have_content title
  end

  scenario 'validations on adding job opening' do
    click_link 'Job Openings'
    find_link('Add a Job Opening').click
    click_button 'Save'
    page.should have_content "Title can't be blank"
    page.should have_content "Department can't be blank"
  end

  scenario 'Validations on editing job opening' do
    add_job_opening(title, 'Customer Support')
    click_link 'Job Openings'
    find(:xpath, "//tr[td[contains(., '#{title}')]]/td/a", :text => 'Edit').click
    fill_in 'opening_title', with: ''
    click_button 'Save'
    page.should have_content "Title can't be blank"
    click_link 'Job Openings'
    delete_job_opening(title)
  end
end
