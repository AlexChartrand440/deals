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

    describe "show" do
      before do
        @product = FactoryGirl.create(:product, seller: seller)
        visit brand_sales_item_path(seller, @product)
      end

      it { should have_selector('title', text: @product.title) }

      describe "when product belongs to seller" do
        it { should have_link('Edit') }
        
        describe "after logging out" do
          before do
            click_link 'Logout'
            visit brand_sales_item_path(seller, @product)
          end
          it { should_not have_link('Edit') }
        end
      end
    end
  end


  describe "as shopper" do
    context "shop by brand" do
      describe "index" do
        let(:seller){ FactoryGirl.create(:seller) }
        before do
          5.times { FactoryGirl.create(:product, seller: seller) }
          visit brand_sales_items_path(seller)
        end

        it { should have_selector('title', text: "by #{seller.brand}") }

        it "should list products by this seller" do
          seller.products.each do |p|
            should have_selector('li', text: p.title)
          end
        end

        it "should not list products by other brands(sellers)" do
          seller.products.destroy_all #to avoid pagination from disturbing with this test
          other_seller = FactoryGirl.create(:seller)
          FactoryGirl.create(:product, seller: other_seller)
          visit brand_sales_items_path(seller)
          page.should_not have_content(other_seller.products.first.title)
        end

        it "should contain links to product show page" do
          product = seller.products.first
          click_link product.title
          current_path.should == brand_sales_item_path(seller, product)
        end

        it "should have pagination"
      end
    end

    context "shop by category" do
      describe "index" do
        let(:seller){ FactoryGirl.create(:seller) }
        let(:category){ FactoryGirl.create(:category) }
        before do
          10.times do
            product = FactoryGirl.create(:product, seller: seller)
            product.categorizations.create(category_id: category.id)
          end
          visit category_sales_items_path(category)
        end 

        it { should have_selector('title', text: "#{category.name}") }

        it "should list products in this category" do
          category.products.each do |p|
            should have_selector('li', text: p.title)
          end
        end

        it "should not list products from other categories" do
          Product.destroy_all #to make sure pagination doesn't affect this test
          other_category = FactoryGirl.create(:category)
          product = FactoryGirl.create(:product)
          product.categorizations.create(category_id: other_category.id)
          visit category_sales_items_path(category)
          should_not have_content(other_category.products.first.title)
        end

        it "should contain links to product show page" do
          product = category.products.first
          click_link product.title
          current_path.should == brand_sales_item_path(seller, product)
        end

        it "should have pagination"

      end
    end

    describe "show" do
      let(:seller) { FactoryGirl.create(:seller) }
      let(:product) { FactoryGirl.create(:product, seller: seller) }
      before do
        visit brand_sales_item_path(seller, product)
      end

      it { should have_selector('title', text:"#{product.title}") }
      it { should have_selector('h2', text:"#{product.title}") }
    end
  end
end
