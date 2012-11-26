require 'spec_helper'

describe Product do
  let(:seller){ FactoryGirl.create(:user, seller: true) }
  before { @product = seller.products.build(title: 'Product 1', price: 23.45, description: 'Lorem Ipsum Color Dolor') }
  subject { @product }

  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:description) }
  it { should respond_to(:seller_id) }
  it { should respond_to(:seller) }
  it { should respond_to(:images) }

  its(:seller){ should == seller }
  it { should be_valid }


end
