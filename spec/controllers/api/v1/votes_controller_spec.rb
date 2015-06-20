require 'rails_helper'

RSpec.describe Api::V1::VotesController, type: :controller do
  let(:link) { FactoryGirl.create :link }

  describe "POST #create" do
    context "when is success" do
      before(:each) do
        post :create, link_id: link.id, vote: { like: true }
      end

      it "renders the vote if created" do
        expect(json_response[:vote]).to have_key(:id)
      end

      it { should respond_with 201 }
    end

    context "when vote is not created" do
      before(:each) do
        post :create, link_id: link.id, vote: { like: nil }
      end

      it "renders link without vote" do
        expect(json_response[:vote]).to have_key(:errors)
      end

      it { should respond_with 422 }
    end
  end

end
