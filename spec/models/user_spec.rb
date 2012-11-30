# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#  seller                 :boolean          default(FALSE)
#  first_name             :string(255)
#  last_name              :string(255)
#  brand                  :string(255)
#  slug                   :string(255)
#

require 'spec_helper'

describe User do
  before do
    @user = User.new(first_name: "Josh", last_name: "Teng", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    @seller = User.new(first_name: "Josh", last_name: "Teng", email: "seller@example.com", password: "foobar", password_confirmation: "foobar", seller:true, brand: "ABC Store")#just to test attr_accessible whitelist
  end

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:addresses) }
  it { should respond_to(:brand) }
  it { should respond_to(:seller) }
  it { should respond_to(:admin) }
  it { should be_valid }

  it { should_not be_seller }
  it { should_not be_admin }

  it { @seller.should be_seller }#just to test attr_accessible whitelist
  it { @seller.should be_valid }#just to test attr_accessible whitelist

  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "basic validations" do
    describe "with a brand name" do
      before { @user.brand = "Hello" }
      it { should_not be_valid }#only sellers can hv brand names
    end

    describe "with a slug" do
      before { @user.slug = "Hello" }
      it { should_not be_valid }#only sellers can hv slugs
    end

    describe "without an email" do
      before { @user.email = "" }
      it { should_not be_valid }
    end

    describe "without a password confirmation" do
      before { @user.password_confirmation = "" }
      it { should_not be_valid }
    end

    describe "without a password" do
      before { @user.password = "" }
      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          @user.should_not be_valid
        end
      end
    end

    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          @user.should be_valid
        end
      end
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email =  @user.email.upcase
        user_with_same_email.save
      end
      it { should_not be_valid }
    end

    describe "toggling user's role" do
      before { @user.save }

      describe "with seller attribute set to 'true'" do
        before { @user.toggle!(:seller) } 
        it { should be_seller }
      end


      describe "with admin attribute set to 'true'" do
        before { @user.toggle!(:admin) }
        it { should be_admin }
      end
    end

    describe "making a user a seller" do
      before do 
        @user.seller = true
        @user.brand = "Atom Retail"
      end

      it { should be_valid }
      it { should be_seller }

      describe "without a brand name" do
        before { @user.brand = "" }
        it { should_not be_valid }
      end

      describe "should create a slug automatically" do
        before { @user.save }#it creates slug on validation
        its(:slug) { should_not be_blank }
      end

      describe "without a unique brand name regardless of casing" do
        before do
          @seller.save
          @dup_seller = @seller.dup
          @dup_seller.email = "unique@example.com"
          @dup_seller.brand = @seller.brand.upcase
        end
        it { @dup_seller.should_not be_valid }
      end
    end
  end

  describe "product associations" do
    before { @seller.save }

    let!(:older_product) do
      FactoryGirl.create(:product, seller: @seller, created_at: 1.day.ago)
    end

    let!(:newer_product) do
      FactoryGirl.create(:product, seller: @seller, created_at: 1.hour.ago)
    end

    it "should have the right products in the right order" do #should this test go into product spec?
      @seller.products.should == [newer_product, older_product]
    end

    it "should destroy associated products" do
      products = @seller.products
      @seller.destroy
      products.each do |product|
        Product.find_by_id(product.id).should be_nil
      end
    end
  end


end
