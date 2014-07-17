class FrontpageController < ApplicationController
  def index
    @records_count = Station.count
    @results = []
    if params[:q] && params[:q].gsub(',', '.').to_f > 0
      # wyszukuję po częstotliwości
      Frequency.where(:mhz => params[:q].gsub(',', '.').to_f).includes(:stations).each do |frequency|
        frequency.stations.each do |station|
          @results << station
        end
      end
      @results.uniq!{|station| station.id}
    elsif params[:q].to_s.strip.length > 3
      # wyszukuję po lokalizacji
      @results = Station.where('stations.location LIKE :q OR stations.name LIKE :q OR operators.name LIKE :q', {q: "%#{params[:q]}%"}).joins(:operator).order('operators.name_unified').all
    end
    @results_markers = @results.map{|station| {title: station.display_name, lat: station.lat, lng: station.lon}}
  end
end