# == Schema Information
#
# Table name: product_images
#
#  id         :integer          not null, primary key
#  product_id :integer
#  image      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

  after do
    @product_image.destroy
  end

  subject{ @product_image }

  it { should respond_to(:image) }
  it { should respond_to(:product) }
  it { should respond_to(:product_id) }

  it { should be_valid }

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

    describe "preventing duplicate" do
      # I want to prevent similar images from being uploaded... Currently, even with similar image name, the image will be uploaded successfully and will display twice! but this is not to critical since the person who uploads is not blind. They can always delete any duplicate images! The key lies in the naming of the file.. see ImageUploader! The file name is given based on the ID of the image in the product_images table which will always be unique and incrementing.....
    end
  end

  describe "accessible attributes" do
    it "should not allow access to product id" do
      expect do
        Product.new(product_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
