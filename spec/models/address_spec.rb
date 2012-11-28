# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  address_1  :string(255)
#  address_2  :string(255)
#  city       :string(255)
#  post_code  :string(255)
#  state      :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Address do
  let(:user) { FactoryGirl.create(:user) }
  before { @address = user.addresses.build(address_1: '277 Cherry St.', city: 'Atlanta', country: 'U.S.A.', post_code: '232323', state: 'GA') }
  subject { @address }

  it { should respond_to(:address_1) }
  it { should respond_to(:address_2) }
  it { should respond_to(:city) }
  it { should respond_to(:country) }
  it { should respond_to(:post_code) }
  it { should respond_to(:state) }
  it { should respond_to(:user_id) }
  it { should be_valid }

  it { should respond_to(:user) }
  its(:user){ should == user }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Address.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "without an associated user" do
    before { @address.user_id = "" }
    it { should_not be_valid }
  end 

  describe "without address 1" do
    before { @address.address_1 = "" }
    it { should_not be_valid }
  end

  describe "without city" do
    before { @address.city = "" }
    it { should_not be_valid }
  end

  describe "without country" do
    before { @address.country = "" }
    it { should_not be_valid }
  end

  describe "without post code" do
    before { @address.post_code = "" }
    it { should_not be_valid }
  end

  describe "without a state" do
    before { @address.state = "" }
    it { should_not be_valid }
  end

  describe "when postcode format is invalid" do
    it "should be invalid" do
      postcode = %w[aj2232j, dsdddd]
      postcode.each do |invalid_postcode|
        @address.post_code = invalid_postcode
        @address.should_not be_valid
      end
    end
  end

  describe "when postcode format is valid" do
    it "should be valid" do
      @address.post_code = "12443"
      @address.should be_valid
    end
  end
end
