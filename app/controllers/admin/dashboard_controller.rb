class Admin::DashboardController < ApplicationController
  http_basic_authenticate_with name: ENV['SOME_USER'], password: ENV['SOME_PASSWORD']
  def show
  end
end
