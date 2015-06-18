require 'rails_helper'

RSpec.describe Api::V1::LinksController, :type => :controller do

  describe "GET #index" do

   context "when the search param is NOT present" do
      before(:each) do
       4.times { FactoryGirl.create(:link) }
       get :index
      end

      it "returns 4 records" do
       links_response = JSON.parse(response.body, symbolize_names: true)

       expect(links_response[:links]).to have(4).items #rspec-collection_matchers
      end

   end

   context "when the search param is present" do
      before(:each) do
        FactoryGirl.create :link, title: "new iphone 1"
        FactoryGirl.create :link, title: "new iphone 2"
        FactoryGirl.create :link, title: "new iphone 3"
        FactoryGirl.create :link, title: "Apple tv"

        get :index, search: "new iphone"
      end

      it "returns 3 records" do
       links_response = JSON.parse(response.body, symbolize_names: true)
       expect(links_response[:links]).to have(3).items #rspec-collection_matchers
      end
   end

  end

  describe "GET #show" do

    before(:each) do
      @link = FactoryGirl.create :link
      get :show, id: @link.id
    end

    it "returns a signle word" do
      link_response = JSON.parse(response.body, symbolize_names: true)
      expect(link_response[:link][:id]).to eq(@link.id)
    end

  end

end
