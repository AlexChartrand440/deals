# == Schema Information
#
# Table name: products
#
#  id                        :integer          not null, primary key
#  seller_id                 :integer
#  title                     :string(255)
#  price                     :decimal(8, 2)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  slug                      :string(255)
#  status                    :boolean          default(FALSE)
#  quantity                  :integer          default(0)
#  discounted_price          :decimal(8, 2)
#  discounted_percentage_off :integer
#  discount_start_date       :date
#  discount_end_date         :date
#  discount_days_left        :integer
#  for_sale                  :boolean          default(FALSE)
#

require 'spec_helper'

describe Product do
  let(:seller){ FactoryGirl.create(:seller) }
  before do
    @product_attributes = { title: "fwefwe", price: 25.45, discounted_price: 25, discount_start_date: Date.tomorrow, discount_end_date: Date.tomorrow + 1  }
    @product = seller.products.build(@product_attributes)
  end
  subject { @product }

  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:status) }
  it { should respond_to(:quantity) }
  it { should respond_to(:discounted_price) }
  it { should respond_to(:discounted_percentage_off) }
  it { should respond_to(:discount_start_date) }
  it { should respond_to(:discount_end_date) }
  it { should respond_to(:discount_days_left) }
  it { should respond_to(:for_sale) }
  it { should respond_to(:description) }
  it { should respond_to(:seller_id) }
  it { should respond_to(:seller) }
  it { should respond_to(:images) }
  it { should respond_to(:categories) }
  it { should respond_to(:categorizations) }

  its(:seller){ should eql(seller) }#check to be same person
  its(:seller){ should be_seller }#check that the person is an approved seller
  its(:status){ should be_true }
  its(:for_sale){ should be_false }
  its(:quantity){ should eql(0) }#zero for now until options are inputted
  its(:discount_days_left){ should be_blank }#it should be blank until cron job runs and for_sale is true
  its(:discounted_percentage_off){ should be_blank }# it should not be blank actually!

  it { should be_valid }

  describe "accessible attributes" do
    it "should allow access to" do
      accessible_attributes = { title: "fwefwe", price: 25, status: false, discounted_price: 25, discount_start_date: Time.now, discount_end_date: Time.now }
      accessible_attributes.each do |a|
        expect do
          Product.new(Hash[*a.flatten])
        end.to_not raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    it "should not allow access to" do
      inaccessible_attributes = { seller_id: 1, discounted_percentage_off: 25, quantity: 25, discount_days_left: 25, for_sale: true, slug: "slug" }
      inaccessible_attributes.each do |a|
        expect do
          Product.new(Hash[*a.flatten])
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  describe "validations" do
    describe "when discount_start_date is today" do
      before { @product.discount_start_date = Date.today }
      it { should_not be_valid }
    end
    describe "when discount_start_date is before today" do
      before { @product.discount_start_date = Date.yesterday }
      it { should_not be_valid }
    end

    describe "when discount_end_date is before discount_start_date (end date < start date)" do
      before do
        @product.discount_start_date = Date.tomorrow + 1
        @product.discount_end_date = Date.tomorrow
      end
      it { should_not be_valid }
    end

    describe "when discount_end_date is the same as discount_start_date (end date = start date)" do
      before do
        @product.discount_start_date = Date.tomorrow + 1
        @product.discount_end_date = Date.tomorrow + 1
      end
      it { should be_valid }
    end

    describe "when discount_start_date is not present" do
      before { @product.discount_start_date = "" }
      it { should_not be_valid }
    end

    describe "when discount_end_date is not present" do
      before { @product.discount_end_date = "" }
      it { should_not be_valid }
    end

    describe "when discounted price is the same as the regular price" do
      before { @product.discounted_price = @product.price }
      it { should_not be_valid }
    end

    describe "when discounted price is more than regular price" do
      before { @product.discounted_price = @product.price + 1 }
      it { should_not be_valid }
    end

    describe "when discounted price is absent" do
      before { @product.discounted_price = "" }
      it { should_not be_valid }
    end

    describe "when quantity is less than 0" do
      before { @product.quantity = -1 }
      it { should_not be_valid }
    end

    it "should have quantity greater than 0 on create and update" #OR should I just warn the seller that it's quantity is 0??? #summation of quantities of different options




    describe "when created by a user who isn't a seller" do
      let(:not_seller){ FactoryGirl.create(:user) }
      it "should not be able to create" do
        product = not_seller.products.build(@product_attributes)
        expect { product.save }.to_not change{ Product.count }
      end
    end

    describe "without a seller" do
      before { @product = Product.new(@product_attributes) }
      it { should_not be_valid }
    end

    describe "without a title" do
      before { @product.title = "" }
      it { should_not be_valid }
    end

    describe "without a price" do
      before { @product.price = "" }
      it { should_not be_valid }
    end
  end

  describe "categories association" do
    let(:category){ FactoryGirl.create(:category) }
    let(:category2){ FactoryGirl.create(:category) }
    before do
      @product.save
      @product.categorizations.create(category_id: category.id)
      @product.categorizations.create(category_id: category2.id)
    end
    its(:categories){ should include(category, category2) }
  end

  describe "description association" do
    before do
      @product.save
      @description = @product.create_description(text: "Lorem Ipsum Color Dolor")
    end
    its(:description){ should eql(@description) }

    it "should destroy associated description" do
      description = @product.description
      @product.destroy
      ProductDescription.find_by_id(description.id).should be_nil
    end
  end


end
