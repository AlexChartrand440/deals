# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Category do
  before do
    @category = Category.new(name: Faker::Company.name)
  end

  subject { @category }

  it { should respond_to(:name) }
  it { should respond_to(:products) }
  it { should respond_to(:categorizations) }

  it { should be_valid }

  describe "without a name" do
    before do
      @category.name = ""
    end

    it { should_not be_valid }
  end

  describe "without a unique name (regardless of case)" do
    before do
      @category.save
      @category = @category.dup
      @category.name.upcase
    end

    it { should_not be_valid }
  end
end
