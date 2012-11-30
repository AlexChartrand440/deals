# == Schema Information
#
# Table name: product_descriptions
#
#  id         :integer          not null, primary key
#  product_id :integer
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe ProductDescription do
  let(:product){ FactoryGirl.create(:product) }
  before { @description = product.create_description(text: "Lorem Ipsum Color Dolor Sit Et") }
  subject { @description }

  it { should respond_to(:product) }
  it { should respond_to(:product_id) }
  it { should respond_to(:text) }

  it { should be_valid }

  its(:product){ should eql(product) }

  describe "without a product associated" do
    before { @description = ProductDescription.new(text:"fewjngwejfnewfjewn") }
    it { should_not be_valid }
  end

  describe "for a product" do
    before do
      puts "#{ProductDescription.count}"
      @description = product.build_description(text:"another description")
      puts "#{ProductDescription.count}"
    end

    it "should not be more than one" do
      expect{ @description.save }.to change{ ProductDescription.count }.from(0).to(1)
    end
  end

  describe "accessible attributes" do
    it "should not allow access to product_id" do
      expect do
        ProductDescription.new(product_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end


end
