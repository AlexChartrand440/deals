# == Schema Information
#
# Table name: categorizations
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Categorization do
  let(:category){ FactoryGirl.create(:category) }
  let(:product){ FactoryGirl.create(:product) }

  before do
    @entry = product.categorizations.create(category_id: category.id)
  end

  subject { @entry }

  it { should respond_to(:category) }
  it { should respond_to(:product) }

  it { should be_valid }

  describe "basic validations" do
    describe "without a category" do
      before { @entry.category_id = nil }
      it { should_not be_valid }
    end

    describe "without a product" do
      before { @entry.product_id = nil }
      it { should_not be_valid }
    end

    describe "duplicate entry" do
      before do
        @entry.save
        @entry = @entry.dup
      end

      it { should_not be_valid }
    end
  end

  describe "accessible attributes" do
    it "should not allow access to product_id" do
      expect do
        Categorization.new(product_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end


end
