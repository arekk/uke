# encoding: utf-8
module ApplicationHelper
  def current_controller_class
    (params[:controller].gsub(/\//, '-') + '-' + controller.action_name) .downcase.gsub(/_/, '-')
  end

  def js_option(option, value)
    @js_options = {} if @js_options.nil?
    @js_options.store(option, value)
  end

  def format_frequency(list)
    simple_format list.map{|frequency| number_with_precision(frequency.mhz, :precision => 4)}.map{|mhz| link_to mhz, root_path(q: mhz)}.join("\n")
  end

  def result_stations_to_g_markers(stations)
    stations.map do |station|
      {title: "#{station.operator.name}<br />#{station.name}<br />#{station.location}<br /><br />TX:<br />" + format_frequency(station.tx_frequencies) + 'RX: <br />' + format_frequency(station.rx_frequencies),
      lat: station.lat,
      lng: station.lon,
      station_type: station.transmission_type}
    end
  end

  def format_date(datetime, format = nil)
    if format.nil?
      I18n.localize datetime, {:format => '%d %B %Y, %A, %H:%M'}
    elsif format == :only_date
      I18n.localize datetime, {:format => '%d %B %Y, %A'}
    else
      I18n.localize datetime, {:format => format}
    end
  end

  def station_net_to_icon(station)
    case station.net
      when 'A'
        content_tag :h2, '', class: 'glyphicon glyphicon-user',       title: 'A: dyspozytorska'
      when 'B'
        content_tag :h2, '', class: 'glyphicon glyphicon-home',       title: 'B: przywoławcza'
      when 'C'
        content_tag :h2, '', class: 'glyphicon glyphicon-transfer',   title: 'C: transmisja danych'
      when 'D'
        content_tag :h2, '', class: 'glyphicon glyphicon-retweet',    title: 'D: retransmisja'
      when 'E'
        content_tag :h2, '', class: 'glyphicon glyphicon-random',     title: 'E: zdalne sterowanie'
      when 'F'
        content_tag :h2, '', class: 'glyphicon glyphicon-bullhorn',   title: 'F: alarm'
      when 'P'
        content_tag :h2, '', class: 'glyphicon glyphicon-eye-open',   title: 'P: bezprzewodowe poszukiwanie osób'
      when 'Q'
        content_tag :h2, '', class: 'glyphicon glyphicon-headphones', title: 'Q: mikrofon bezprzewodowy'
      when 'R'
        content_tag :h2, '', class: 'glyphicon glyphicon-briefcase',  title: 'R: reportażowa'
      when 'T'
        content_tag :h2, '', class: 'glyphicon glyphicon-earphone',   title: 'T: tranking'
      else
        raise 'Unknown net'
    end
  end
end
