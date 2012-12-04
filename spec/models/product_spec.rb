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
#  status                    :boolean          default(TRUE)
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
    @product_attributes = { title: "fwefwe", price: 25.45, discounted_price: 25, discount_start_date: DateTime.now.tomorrow.to_date, discount_end_date: DateTime.now.tomorrow.to_date + 1  }
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
  it { should respond_to(:default_image) }
  it { should respond_to(:images) }
  it { should respond_to(:product_image_attributes) }
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
    its(:categorizations){ should_not be_nil }

    it "should destroy associated categorizations" do
      categorizations = @product.categorizations
      @product.destroy
      categorizations.each do |c|
        Categorization.find_by_id(c.id).should be_nil
      end
    end
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

  describe "ProductImage association" do
    #must have images on product creation? The nested form will take care of this I believe
    before do
      @product.save!
      @product_image = @product.images.new
      @product_image.image = File.open('app/assets/images/rails.png')
      @product_image.save!
    end

    #how to test the url method?
    its(:images){ should include(@product_image) }

    it "should destroy associated images" do
      images = @product.images
      @product.destroy
      images.each do |i|
        ProductImage.find_by_id(i.id).should be_nil
      end
    end

    context "default image functionality" do
      describe "after making an image default" do
        it "should be found through default_image" do
          @product_image.attribute.update_attributes!(default: true)
          @product.default_image.should eql(@product_image)
        end
      end

      describe "without setting a default image" do
        before do
          @another_product_image = @product.images.new
          @another_product_image.image = File.open('app/assets/images/rails.png')
          @another_product_image.save!
        end

        describe "and sort_order" do
          it "should return the one created first (created_at)" do
            @product.default_image.should eql(@product_image)
          end
        end

        describe "when sort_order is set" do
          it "should return the first one in the sort_order" do
            @another_product_image.attribute.update_attributes!(sort_order: 1)
            @product_image.attribute.update_attributes!(sort_order: 2)
            @product.default_image.should eql(@another_product_image)
          end
        end
      end
    end

    context "sorted images functionality" do
      let(:newer_product_image){ FactoryGirl.create(:product_image, product_id: @product) }

      before do
        now = DateTime.now
        newer_product_image.attribute.update_column(:created_at, now)
        @product_image.attribute.update_column(:created_at, now -1)
      end

      it "should return images in chronological order on created_at" do
        @product.sorted_images.should == [@product_image, newer_product_image]
      end

      describe "when sort_order is set" do
        before do
          newer_product_image.attribute.update_attributes!(sort_order: 1)
          @product_image.attribute.update_attributes!(sort_order: 2)
        end

        it "should return images in chronological order based on sort_order" do
          @product.sorted_images.should == [newer_product_image, @product_image]
        end
      end

      describe "when some sort order are set and some are not" do
        before do
          newer_product_image.attribute.update_attributes!(sort_order: 1)
        end

        it "should fall back to sorting images by created_at" do
          @product.sorted_images.should == [@product_image, newer_product_image]
        end
      end
    end

  end
end
