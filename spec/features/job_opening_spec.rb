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
    sign_in(ADMIN_USERNAME, ADMIN_PASSWORD)
  end

  scenario 'check job opening list layout' do
    add_job_opening(title, 'Facility', true, 3, 2)
    click_link 'Job Openings'
    page.should have_content 'Title'
    page.should have_content 'Department'
    page.should have_content 'Hiring Manager'
    page.should have_content 'Status'
    page.should have_content 'Filled/Total'
    page.should have_content '# of Candidates'
    page.should have_content title
    page.should have_content 'System Administrator'
    page.should have_content 'Facility'
    page.should have_content 'Published'
    page.should have_content '2/3'
    click_link 'View All'
    page.should_not have_link 'View All'
    click_link 'View Mine'
    page.should_not have_link 'View Mine'
    page.should have_link 'View All'
    delete_job_opening(title)
  end

  scenario 'add a draft job opening' do
    add_job_opening(title, 'Finance', false, 3, 2, 'System Administrator',
      'System Administrator', 'China', 'Shanghai', 'CityofSH')
    page.should have_content title
    page.should have_content 'System Administrator'
    page.should have_content 'China'
    page.should have_content 'Shanghai'
    page.should have_content 'CityofSH'
    page.should have_content 'draft'
    delete_job_opening(title)
  end

  scenario 'add a published job opening' do
    add_job_opening(title, 'IT', true, 4, 4, 'System Administrator',
      'System Administrator', 'United States', 'New York', 'NYCity')
    page.should have_content title
    page.should have_content 'System Administrator'
    page.should have_content 'United States'
    page.should have_content 'New York'
    page.should have_content 'NYCity'
    page.should have_content 'published'
    delete_job_opening(title)
  end

  scenario 'job opening details' do
    add_job_opening(title, 'Finance', false, 3, 2, 'System Administrator',
      'System Administrator', 'China', 'Shanghai', 'CityofSH', 'join vmware!')
    job_opening_details(title)
    page.should have_content title
    page.should have_content 'System Administrator'
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
    add_job_opening(currentTitle)
    edit_job_opening(currentTitle, newTitle, 'published', 'Finance', 3, 2, '', '', 'China',
      'Shanghai', 'cityofsh', 'editjobopening')
    page.should have_content newTitle
    page.should have_content 'System Administrator'
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
    add_job_opening(currentTitle, '', true)
    edit_job_opening(currentTitle, newTitle, 'closed', 'Finance', 3, 2, '', '', 'United States',
      'New York', 'cityofny', 'editjobopening', 'System Administrator')
    page.should have_content newTitle
    page.should have_content 'System Administrator'
    page.should have_content 'United States'
    page.should have_content 'New York'
    page.should have_content 'cityofny'
    page.should have_content 'closed'
    page.should have_content 'editjobopening'
    delete_job_opening(newTitle)
  end

  scenario 'delete a job opening' do
    add_job_opening(title)
    click_link 'Job Openings'
    page.should have_content title
    delete_job_opening(title)
    page.should_not have_content title
  end

  scenario 'validations on adding job opening' do
    click_link 'Job Openings'
    find_link('Add a Job Opening').click
    fill_in 'opening_filled_no', with: 2
    click_button 'Save'
    page.should have_content "Title can't be blank"
    page.should have_content 'Filled no is larger than total no.'
  end

  scenario 'Validations on editing job opening' do
    add_job_opening(title)
    click_link 'Job Openings'
    find(:xpath, "//tr[td[contains(., '#{title}')]]/td/a", :text => 'Edit').click
    fill_in 'opening_title', with: ''
    fill_in 'opening_filled_no', with: 2
    click_button 'Save'
    page.should have_content "Title can't be blank"
    page.should have_content 'Filled no is larger than total no.'
    click_link 'Job Openings'
    delete_job_opening(title)
  end
end
