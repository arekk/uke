class FrontpageController < ApplicationController
  def index
    @records_count = UkeStation.count
    @finder = (Uke::Finder.new).query(params[:q])
  end
end