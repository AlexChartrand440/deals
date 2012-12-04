# == Schema Information
#
# Table name: product_images
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

require 'spec_helper'
require 'carrierwave/test/matchers'

describe ProductImage do
  include CarrierWave::Test::Matchers

  let(:product) { FactoryGirl.create(:product, id: 358) }

  before do
    @product_image = product.images.new
    @product_image.image = File.open('app/assets/images/rails.png')
  end

  # after(:each) do
  #   @product_image.destroy
  # end

  subject{ @product_image }

  it { should respond_to(:image) }
  it { should respond_to(:attribute) }
  it { should respond_to(:product) }
  it { should respond_to(:product_id) }

  its(:product){ should eql(product) }

  it { should be_valid }

  describe "product image attribute association" do
    describe "create_product_image_attribute callback" do
      it "should auto create attribute on create" do
        expect { @product_image.save }.to change{ ProductImageAttribute.count }.from(0).to(1)
      end

      it "should have the right product_id" do
        @product_image.save
        @product_image.attribute.product_id.should eql(@product_image.product_id)
      end

      it "should be associated to itself" do
        @product_image.save
        ProductImageAttribute.first.image.should eql(@product_image)
      end
    end

    it "should auto destroy attribute on destroy" do
      @product_image.save
      attribute = @product_image.attribute
      @product_image.destroy
      ProductImageAttribute.find_by_id(attribute.id).should be_nil
    end
  end

  describe "basic validations" do
    describe "without product_id" do
      before do
        @product_image.product_id = nil
      end

      it { should_not be_valid }
    end

    describe "without image" do
      before do 
        @product_image = product.images.new
      end

      it { should_not be_valid }
    end

    describe "uploading image with same name" do
      before do
        @new_product_image = product.images.new
        @new_product_image.image = File.open('app/assets/images/rails.png')
        @new_product_image.save!
      end

      it "should successfully save" do
        expect { @product_image.save }.to change{ product.images.count }.from(1).to(2)
        # @product_image.save
        # @product_image.errors.should == {}
      end

      it "should successfully save as 2 different files" do
        @product_image.save
        @product_image.image.should_not eql(@new_product_image.image)
      end

      it "still has issues!!!!! if files are created really fast, i'll override files because same timestamp"

    end
  end

  describe "accessible attributes" do
    it "should allow access to" do
      accessible_attributes = { image: 1 }
      accessible_attributes.each do |a|
        expect do
          ProductImage.new(Hash[*a.flatten])
        end.to_not raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    it "should not allow access to" do
      inaccessible_attributes = { product_id: 1 }
      inaccessible_attributes.each do |a|
        expect do
          ProductImage.new(Hash[*a.flatten])
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  
end
