require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:link) { FactoryGirl.create :link }

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :comment, link: link }
      4.times { FactoryGirl.create :comment }
      get :index, link_id: link.id
    end

    it "renders a comments array" do
      expect(json_response[:comments]).to have(4).items
    end

    it "responds with a 200 code" do
      expect(response.response_code).to be 200
    end

    it "responds with a json" do
      expect(response.content_type).to eq(Mime::JSON)
    end
    
    it_behaves_like "paginated list"
  end

  describe "POST #create" do

    context "when the record is valid" do
      before(:each) do
        post :create, link_id: link.id,
                      comment: { content: FFaker::HipsterIpsum.paragraph }
      end

      it "renders a comment resource created by the server" do
        expect(json_response[:comment]).to have_key(:id)
      end

      it { should respond_with 201 }
    end

    context "when the record is not valid" do
      before(:each) do
        post :create, link_id: link.id,
              comment: { content: "" }
      end

      it "renders the errors from the server" do
        expect(json_response[:comment]).to have_key(:errors)
      end

      it { should respond_with 422 }
    end

  end



  describe "DELETE #destroy" do

    it "returns a 204 http status" do
      comment = FactoryGirl.create :comment
      delete :destroy, id: comment.id

      expect(response.response_code).to be 204
    end
  end
end
