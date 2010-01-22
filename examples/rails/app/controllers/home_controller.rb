class HomeController < ApplicationController
  def index
  end

  def static
    render template: params[:template]
  end
end
