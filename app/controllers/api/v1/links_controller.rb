class Api::V1::LinksController < Api::V1::BaseController
  #endpoints
  def index
    render json: Link.search(params[:search])
  end

  def show
    render json: Link.find(params[:id])
  end

  def update
    link = Link.find(params[:id])

    if link.update(link_params)
      render json: link, status: :ok #o 200
    else
      render json: { link: {errors: link.errors.messages} },
                            status: 422 #o :unprocessable_entity
    end
  end

  private

  def link_params
    params.require(:link).permit(:title, :url)
  end
end
