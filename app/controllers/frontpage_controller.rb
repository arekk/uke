class FrontpageController < ApplicationController
  def index
    @records_count = Station.count
    @finder = (Uke::Finder.new).query(params[:q])
  end
end