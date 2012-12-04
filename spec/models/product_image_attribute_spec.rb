# == Schema Information
#
# Table name: product_image_attributes
#
#  id               :integer          not null, primary key
#  product_id       :integer
#  product_image_id :integer
#  default          :boolean
#  sort_order       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe ProductImageAttribute do
  let(:product_image){ FactoryGirl.create(:product_image) }

  before { @attribute = product_image.attribute }

  subject{ @attribute }

  it { should_not be_nil }

  it { should respond_to(:default) }
  it { should respond_to(:sort_order) }
  it { should respond_to(:product_id) }
  it { should respond_to(:product_image_id) }
  it { should respond_to(:product) }
  it { should respond_to(:image) }

  it { should be_valid }

  its(:default){ should be_false }

  its(:product){ should eql(product_image.product) }
  its(:image){ should eql(product_image) }

  describe "basic validation" do
    describe "without product_id" do
      before { @attribute.product_id = nil }
      it { should_not be_valid }
    end

    describe "without product_image_id" do
      before { @attribute.product_image_id = nil }
      it { should_not be_valid }
    end

    describe "non-integer sort order" do
      before { @attribute.sort_order = "a" }
      it { should_not be_valid }
    end

    describe "negative number sort order" do
      before { @attribute.sort_order = -1 }
      it { should_not be_valid }
    end

    #should I prevent sort order number to be greater than the number of pictures

    describe "2 or more similar sort order numbers, same product" do
      before do
        @new_product_image = FactoryGirl.create(:product_image, product: @attribute.product)
        @new_product_image.attribute.update_attributes!(sort_order: 1)
        @attribute.sort_order = 1
      end

      it { should_not be_valid }

      it "should be able to save if sort order changed to 2" do
        @attribute.sort_order = 2
        should be_valid
      end

    end

    describe "2 or more similar sort order numbers for different products" do
      before do
        product2 = FactoryGirl.create(:product)
        @new_product_image = FactoryGirl.create(:product_image, product: product2)
        @new_product_image.attribute.update_attributes!(sort_order: 1)
        @attribute.sort_order = 1
      end

      it { should be_valid }
    end
  end

  describe "callbacks" do
    describe "before save" do
      describe "when a new default image is created for a product with existing default image" do
        before do
          old_default_image = FactoryGirl.create(:product_image, product: @attribute.product)
          old_default_image.attribute.update_attributes!(default: true)
          @old_attribute = old_default_image.attribute
          @attribute.default = true
        end

        it "should change the old default image from true to false" do
          expect { @attribute.save }.to change{ ProductImageAttribute.find(@old_attribute).default }.from(true).to(false)
        end

        it { should be_default }#changes the new default image as the default image
      end

      #control for set_old_default_image_to_false
      describe "2 default images for different products" do
        before do
          product2 = FactoryGirl.create(:product)
          default_image_of_another_product = FactoryGirl.create(:product_image, product: product2)
          default_image_of_another_product.attribute.update_attributes!(default: true)
          @attribute_for_default_image_of_another_product = default_image_of_another_product.attribute
          @attribute.update_attributes!(default: true)
        end

        its(:default){ should eql(true) }

        it "should not change default status for previous default image belonging to different products (to false)" do
          @attribute_for_default_image_of_another_product.reload.default.should eql(true)
        end
      end
    end
  end


  describe "accessible attributes" do
    it "should allow access to" do
      accessible_attributes = { product_id: 1, default: true, sort_order: 4 }
      accessible_attributes.each do |a|
        expect do
          ProductImageAttribute.new(Hash[*a.flatten])
        end.to_not raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    it "should not allow access to" do
      inaccessible_attributes = { product_image_id: 1 }
      inaccessible_attributes.each do |a|
        expect do
          ProductImageAttribute.new(Hash[*a.flatten])
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end
end
