class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def index
    render json: { status: "ok"}
  end

end
