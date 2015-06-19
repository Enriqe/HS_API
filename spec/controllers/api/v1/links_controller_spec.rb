require 'rails_helper'

RSpec.describe Api::V1::LinksController, :type => :controller do

  describe "GET #index" do

   context "when the search param is NOT present" do
      before(:each) do
       4.times { FactoryGirl.create(:link) }
       get :index
      end

      it "returns 4 records" do
       links_response = json_response
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
       links_response = json_response
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
      link_response = json_response
      expect(link_response[:link][:id]).to eq(@link.id)
    end

  end

  describe "PUT/PATCH #update" do

    before(:each) do
      @link = FactoryGirl.create :link
    end

    it "updates the link 'title' to 'The new iPhone is out!'" do
      put :update, {  id: @link.id,  link: { title: "The new iPhone is out!" } }
      link_response = json_response
      expect(link_response[:link][:title]).to eq "The new iPhone is out!"
    end

    context 'when record does not update' do
      before (:each) do
        put :update, { id: @link.id, link: { title: "" } }
      end

      it "with a blank title" do
        link_response = json_response
        expect(link_response[:link][:errors][:title]).to include I18n.t('errors.messages.blank')
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before (:each) do
      @link = FactoryGirl.create :link
      delete :destroy, id: @link.id
    end

    it { should respond_with 204 }
  end

  describe "POST #create" do

    it "render the link record if success" do
      post :create, { link: {title: "Look mom I'm hacking", url: "http://imawesome.com"} }
      #alternativa:
      #post :create, link: FactoryGirl.attributes_for(:link)

      link_response = json_response
      expect(link_response[:link][:title]).to eq "Look mom I'm hacking"
      #alternative
      #expect(link_response[:link]).to have_key(:title)
    end

    it "render errors if link not saved" do
      post :create, { link: {title: "", url: "http://imawesome.com"} }
      link_response = json_response
      expect(link_response[:link][:errors][:title]).to include I18n.t('errors.messages.blank')
    end
  end
end
