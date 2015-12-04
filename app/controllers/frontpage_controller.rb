class FrontpageController < ApplicationController
  def index
    @finder = (Uke::Finder.new).query(params[:q])
    @records_count = @finder.active_import.uke_stations.count
    @released_on = @finder.active_import.released_on
  end
  
  def xml
    @finder = (Uke::Finder.new).query(params[:q], 10000)
    render(:template => "frontpage/xml", :layout => false)
  end
end