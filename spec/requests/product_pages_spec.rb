require 'spec_helper'

describe "ProductPages" do
  subject { page }

  describe "as a seller" do
    let(:seller){ FactoryGirl.create(:seller) }
    before do
      sign_in seller
    end

    describe "new page" do
      before { visit new_admin_item_path }


    end

    describe "edit page" do
      before { visit edit_admin_item_path }
    end

    describe "create action" do
    end

    describe "update action" do
    end
  end


  describe "as shopper" do
    context "shop by brand" do
      describe "index" do
        let(:seller){ FactoryGirl.create(:seller) }
        before do
          30.times { FactoryGirl.create(:product, seller: seller) }
          visit brand_items_path(seller)
        end

        it { should have_selector('title', text: "by #{seller.brand}") }
        it "should list products by brand"
        it "should list products in newest first order"
        it "should have pagination"
        it "should contain links to product show page"
      end
    end

    context "shop by category" do
      describe "index" do
        let(:seller){ FactoryGirl.create(:seller) }
        let(:category){ FactoryGirl.create(:category) }
        before do
          30.times do
            product = FactoryGirl.create(:product, seller: seller)
            product.categorizations.create(category_id: category.id)
          end
          visit category_items_path(category)
        end 

        it { should have_selector('title', text: "by #{category.name}") }
        it "should have pagination"
        it "should list products by category"
        it "should list product by created_at date in descending order"
        it "should contain links to product show page"
      end
    end

    describe "show" do
      let(:seller) { FactoryGirl.create(:seller) }
      let(:product) { FactoryGirl.create(:product, seller: seller) }
      before do
        visit brand_item_path(seller, product)
      end

      it { should have_selector('title', text:"#{product.title}") }
      it { should have_selector('h2', text:"#{product.title}") }
    end
  end
end
