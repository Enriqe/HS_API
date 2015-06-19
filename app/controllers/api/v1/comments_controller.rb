class Api::V1::CommentsController < ApplicationController

  def index
    #link = Link.find(params[:link_id])
    render json: Comment.where(link_id: params[:link_id])
  end
end
