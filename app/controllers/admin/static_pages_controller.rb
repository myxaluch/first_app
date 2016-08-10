class Admin::StaticPagesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "password"
  layout 'admin'

  def index
  end

end
