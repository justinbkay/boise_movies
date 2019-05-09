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

end