# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  seller_id   :integer
#  title       :string(255)
#  price       :decimal(8, 2)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Product do
  let(:seller){ FactoryGirl.create(:seller) }
  let(:category){ FactoryGirl.create(:category) }
  before do
    @product = seller.products.build(title: 'Product 1', price: 23.45, description: 'Lorem Ipsum Color Dolor')
  end
  subject { @product }

  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:description) }
  it { should respond_to(:seller_id) }
  it { should respond_to(:seller) }
  it { should respond_to(:images) }
  it { should respond_to(:categories) }
  it { should respond_to(:categorizations) }

  its(:seller){ should eql(seller) }
  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to seller_id" do
      expect do
        Product.new(seller_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "categories association" do
    before do
      @product.save
      @product.categorizations.create(category_id: category.id)
    end
    its(:categories){ should include(category) }
  end

  describe "validations" do
    describe "without a seller" do
      before { @product = Product.new(title: 'Product 1', price: 23.45, description: 'Lorem Ipsum Color Dolor') }
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


end
