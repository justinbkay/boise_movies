require 'rails_helper'

RSpec.feature 'Theater management requires login', type: :feature do
  scenario 'User tries to visit theaters index before login' do
    visit '/theaters/'

    # expect(page).to have_text('Rating Filter:')
    expect(current_path).to eq('/')
  end
end