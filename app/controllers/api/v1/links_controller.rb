class Api::V1::LinksController < Api::V1::BaseController

  def index
    render json: Link.search(params[:search])
  end
end
