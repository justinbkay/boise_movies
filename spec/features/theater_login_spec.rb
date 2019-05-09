require 'rails_helper'

RSpec.feature 'Theater management requires login', type: :feature do
  scenario 'User tries to visit theaters index before login' do
    visit '/theaters/'

    # expect(page).to have_text('Rating Filter:')
    expect(current_path).to eq('/')
  end

  scenario 'User logs in and tries to visit theaters index' do
    visit '/sessions/new'
    fill_in('username', with: Rails.application.credentials.admin_user)
    fill_in('password', with: Rails.application.credentials.admin_password)
    click_button('Log In')
    expect(current_path).to eq('/theaters')
  end

  scenario 'User uses incorrect username or password' do
    visit '/sessions/new'
    fill_in('username', with: 'admin')
    fill_in('password', with: 'password')
    click_button('Log In')
    expect(current_path).to eq('/sessions')
  end

  scenario 'User can log in and log out' do
    visit '/sessions/new'
    fill_in('username', with: Rails.application.credentials.admin_user)
    fill_in('password', with: Rails.application.credentials.admin_password)
    click_button('Log In')
    click_link('Log Out')
    expect(current_path).to eq('/')
  end

end