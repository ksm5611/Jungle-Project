
require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    User.new(first_name: "hoho", last_name: "lee", email: "test@test.com", password: 'aaabbbb', password_confirmation: 'aaabbbb')
  }

  describe 'Validations' do

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it "is not valid if password and password_confirmation does not match" do
      subject.password = "aaabbbb"
      expect(subject).to be_valid
    end

    it "is not valid if the password is too short" do
      subject.password = "aaa"
      subject.password_confirmation ="aaa"
      expect(subject).to_not be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if email already exists" do
      User.create(first_name: "hoho",  last_name: "lee", email: "test@test.com", password: "aaabbbb", password_confirmation: "aaabbbb")
      expect(subject).to_not be_valid
    end

    it "is not valid if email is not unique without caplocks" do
      User.create(first_name: "hoho", last_name: "lee", email: "test@test.Com", password: "aaabbbb", password_confirmation: "aaabbbb")

      expect(subject).to_not be_valid
    end

    it "is not valid without a first name" do
      subject.first_name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a last name" do
      subject.last_name = nil
      expect(subject).to_not be_valid
    end
  end

  describe '.authenticate_with_credentials' do

    it 'should match password and email' do
      user = User.create(first_name: 'hoho', last_name: 'lee',
        email: 'test@test.com', password: 'aaabbbb',
        password_confirmation: 'aaabbbb')

      session = User.authenticate_with_credentials('test@test.com', 'aaabbbb')

      expect(session).to eq user
    end

    it 'should match when there is a space in front of email' do
      user = User.create(first_name: 'hoho', last_name: 'lee',
        email: 'test@test.com', password: 'aaabbbb',
        password_confirmation: 'aaabbbb')

      session = User.authenticate_with_credentials(' test@test.com', 'aaabbbb')
      expect(session).to eq user
    end

    it 'should match when there is a space at the end of the email' do
      user = User.create(first_name: 'hoho', last_name: 'lee',
        email: 'test@test.com', password: 'aaabbbb',
        password_confirmation: 'aaabbbb')

      session = User.authenticate_with_credentials('test@test.com ', 'aaabbbb')
      expect(session).to eq user
    end

    it 'should match when user types wrong cases' do
      @user = User.create(first_name: 'hoho', last_name: 'lee',
        email: 'test@test.com', password: 'aaabbbb',
        password_confirmation: 'aaabbbb')

      session = User.authenticate_with_credentials('TEST@test.com ', 'aaabbbb')
      expect(session).to eq @user
    end
  end
end