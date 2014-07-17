class FrontpageController < ApplicationController
  def index
    @records_count = Station.count
    @results = []
    @g_result = nil

    if params[:q] && params[:q].gsub(',', '.').to_f > 0
      # wyszukuję po częstotliwości
      Frequency.where(:mhz => params[:q].gsub(',', '.').to_f).includes(:stations).each do |frequency|
        frequency.stations.each do |station|
          @results << station
        end
      end
      @results.uniq!{|station| station.id}
    elsif params[:q].to_s.strip[0..3] == 'loc:'
      # podano tak lokalizacyjny, wyszukuję stacje w promieniu
      unless (@g_result = Geocoder.search(params[:q].gsub('loc:', '').strip).first).nil?
        @results = Station.find_by_sql("
          SELECT *, (3959 * acos (cos ( radians(#{@g_result.latitude.to_f}) ) * cos( radians( lat ) ) * cos( radians( lon ) - radians(#{@g_result.longitude.to_f}) ) + sin ( radians(#{@g_result.latitude.to_f}) ) * sin( radians( lat ) ))) AS distance
          FROM stations
          HAVING distance < 15
          ORDER BY distance");
      end
    elsif params[:q].to_s.strip.length > 3
      # wyszukuję po lokalizacji
      @results = Station.where('stations.location LIKE :q OR stations.name LIKE :q OR operators.name LIKE :q', {q: "%#{params[:q]}%"}).joins(:operator).order('operators.name_unified').all
    end
    @results_markers = @results.map{|station| {title: station.display_name, lat: station.lat, lng: station.lon}}
  end
end