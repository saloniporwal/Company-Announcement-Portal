require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  # Validation tests
  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is not valid without a first name' do
    user.first_name = nil
    expect(user).not_to be_valid
  end

  it 'is not valid without a last name' do
    user.last_name = nil
    expect(user).not_to be_valid
  end

  it 'is not valid without a date of birth' do
    user.dob = nil
    expect(user).not_to be_valid
  end

  it 'is not valid without an address' do
    user.address = nil
    expect(user).not_to be_valid
  end

  it 'is not valid without a mobile number' do
    user.mobile_number = nil
    expect(user).not_to be_valid
  end

  it 'is not valid without a gender' do
    user.gender = nil
    expect(user).not_to be_valid
  end

  it 'is not valid with a non-unique email' do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    expect(duplicate_user).not_to be_valid
  end

  # Association tests
  it 'has many posts' do
    association = described_class.reflect_on_association(:posts)
    expect(association.macro).to eq :has_many
  end

  it 'has many comments' do
    association = described_class.reflect_on_association(:comments)
    expect(association.macro).to eq :has_many
  end

  it 'has many written comments' do
    association = described_class.reflect_on_association(:written_comments)
    expect(association.macro).to eq :has_many
  end

  it 'creates a user' do
    user = User.create(
      email: 'saloni@example.com',
      password: 'password123s',
      first_name: 'New',
      last_name: 'User',
      dob: '1990-01-01',
      address: '123 New Street',
      mobile_number: '9893342455',
      gender: 'Female'
    )
    expect(user).to be_valid
  end
end
