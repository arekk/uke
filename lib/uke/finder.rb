class Uke::Finder
  attr_accessor :q, :results, :results_voice, :results_digital, :location

  def initialize
    @results = @results_voice = @results_digital = []
  end

  def any?
    (@results.count > 0)
  end

  def query(value)
    @q = value.to_s

    r = nil
    r = by_location
    r = by_frq_range if r.nil?
    r = by_frq       if r.nil?
    r = by_string    if r.nil?
    r = []           if r.nil?

    @results = r.to_a

    @results_voice   = @results.clone.select{|station| station.voice? }
    @results_digital = @results.clone.select{|station| station.digital? }

    self
  end

  def by_location
    return nil if @q.strip[0..3] != 'loc:' || (@location = Geocoder.search(@q.gsub('loc:', '').strip).first).nil?

    sql = <<-SQL
        SELECT stations.*,
               (3959 * acos(cos(radians(?))*cos(radians(lat))*cos(radians(lon)-radians(?))+sin(radians(?))*sin(radians(lat)))) AS distance
          FROM stations
        HAVING distance < 12
      ORDER BY distance
    SQL
    UkeStation.find_by_sql([sql, @location.latitude.to_f, @location.longitude.to_f, @location.latitude.to_f])
  end

  def by_frq_range
    return nil if @q.strip[0..3] != 'rng:' || (first = @q[4..@q.length].split('-').first.strip.gsub(',', '.').to_f) < 1 || (last =  @q[4..@q.length].split('-').last.strip.gsub(',', '.').to_f) < 1

    sids = UkeStation.find_by_sql ['SELECT fs.station_id AS id FROM frequencies f JOIN frequencies_stations fs ON fs.frequency_id = f.id WHERE f.mhz BETWEEN ? AND ?', first, last]
    wrap_sids sids
  end

  def by_frq_order_by_distance
    sql = <<-SQL
      SELECT uo.name AS owner,
             CONCAT(us.name, ' ', us.location) AS display_name,
             us.net,
             (3959 * acos(cos(radians(:lat))*cos(radians(lat))*cos(radians(lon)-radians(:lon))+sin(radians(:lat))*sin(radians(lat)))) AS distance,
             fa.id AS frequency_assignment_id
      FROM frequencies f
      INNER JOIN frequency_assignments fa ON (fa.frequency_id = f.id AND fa.subject_type = 'UkeStation')
      INNER JOIN uke_stations us ON us.id = fa.subject_id
      INNER JOIN uke_operators uo ON uo.id = us.uke_operator_id
      WHERE mhz = :mhz
      ORDER BY distance ASC
    SQL

    c = ActiveRecord::Base.connection
    result_to_hash(c.select_all(sql.gsub(':lat', c.quote_string(@location.latitude.to_s)).gsub(':lon', c.quote_string(@location.longitude.to_s)).gsub(':mhz', c.quote_string(@q.gsub(',', '.').to_s))))
  end

  def by_frq
    return nil if @q.length < 4 || @q.gsub(',', '.').to_f < 1

    sids = UkeStation.find_by_sql ['SELECT fs.station_id AS id FROM frequencies f JOIN frequencies_stations fs ON fs.frequency_id = f.id WHERE f.mhz = ?', @q.gsub(',', '.').to_f]
    wrap_sids sids
  end

  def by_string
    return nil if @q.length < 4

    like = "%#{@q}%"
    sql = <<-SQL
        SELECT s.*
          FROM stations s
          JOIN operators o on (o.id = s.operator_id)
         WHERE (s.location LIKE ? OR s.name LIKE ? OR o.name LIKE ?)
      ORDER BY o.name_unified
    SQL
    UkeStation.find_by_sql([sql, like, like, like])
  end

  private

  def result_to_hash(result)
    columns = result.columns.map{|column| column.to_sym}
    result.rows.map { |row| Hash[columns.zip(row)] }
  end

  def wrap_sids(sids)
    UkeStation.includes(:operator).where(id: sids.map{|r| r.id}).all
  end
end
