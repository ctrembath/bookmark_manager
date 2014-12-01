require 'spec_helper'
require './app/models/user'
require 'features/helpers/session'
require './app/helpers/application'

include SessionHelpers

feature "User signs up" do

  it "when being logged out" do
    expect{ sign_up }.to change(User, :count).by (1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq("alice@example.com")

  end

  it "with a password that doesn't match" do
    lambda{ sign_up('a@a.com','pass','wrong') }.should change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario "with an email that is already registered" do
    expect{sign_up}.to change(User, :count).by (1)
    expect{sign_up}.to change(User, :count).by (0)
    expect(page).to have_content("This email is already taken")
  end

end

feature "User signs in" do

  before(:each) do
    sign_up("test@test.com", "test", "test")
    click_on "Sign out"
  end

  it "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com','test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  it "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature 'User signs out' do
  
  before(:each) do
    sign_up("test@test.com", "test", "test")
    click_on "Sign out"
  end

  it "while being signed in" do
    sign_in("test@test.com", 'test')
    click_button 'Sign out'
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end

  it "should send an email with password token" do
    visit 'users/reset_password'
    fill_in 'email', with: "test@test.com"
    click_on "Forgot Password"
    expect(page).to have_content "Reset instructions sent to"
  end
  
end

def sign_in(email, password)
  visit '/sessions/new'
  fill_in 'email', :with => email
  fill_in 'password', :with => password
  click_button 'Sign in'
end














