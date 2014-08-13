# encoding: utf-8
module ApplicationHelper
  def current_controller_class
    (params[:controller].gsub(/\//, '-') + '-' + controller.action_name) .downcase.gsub(/_/, '-')
  end

  def js_option(option, value)
    @js_options = {} if @js_options.nil?
    @js_options.store(option, value)
  end

  def format_frequencies(string)
    simple_format string.to_s.split(',').map{|mhz| format_mhz(mhz.strip)}.join("\n")
  end

  def format_mhz(mhz)
    number_with_precision(mhz, :precision => 4)
  end

  def result_stations_to_g_markers(stations)
    stations.map do |station|
      {title: "#{station[:owner]}<br />#{station[:name]}<br />#{station[:location]}<br /><br />TX:<br />" + format_frequencies(station[:tx_frequencies]) + 'RX: <br />' + format_frequencies(station[:rx_frequencies]),
      lat:    station[:lat],
      lng:    station[:lon],
      radius: station[:radius],
      type:   Uke::Net::transmission_type(station[:net])}
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

  def station_net_to_display_name(station_or_net)
    station_or_net = station_or_net.net if station_or_net.respond_to?(:net)
    case station_or_net
      when 'A'
        'dyspozytorska'
      when 'B'
        'przywoławcza'
      when 'C'
        'transmisja danych'
      when 'D'
        'retransmisja'
      when 'E'
        'zdalne sterowanie'
      when 'F'
        'alarm'
      when 'P'
        'bezprzewodowe poszukiwanie osób'
      when 'Q'
        'mikrofon bezprzewodowy'
      when 'R'
        'reportażowa'
      when 'T'
        'tranking'
      else
        raise 'Unknown net'
    end
  end

  def station_net_to_glyphicon(station_or_net)
    station_or_net = station_or_net.net if station_or_net.respond_to?(:net)
    case station_or_net
      when 'A'
        'glyphicon glyphicon-user'
      when 'B'
        'glyphicon glyphicon-home'
      when 'C'
        'glyphicon glyphicon-transfer'
      when 'D'
        'glyphicon glyphicon-retweet'
      when 'E'
        'glyphicon glyphicon-random'
      when 'F'
        'glyphicon glyphicon-bullhorn'
      when 'P'
        'glyphicon glyphicon-eye-open'
      when 'Q'
        'glyphicon glyphicon-headphones'
      when 'R'
        'glyphicon glyphicon-briefcase'
      when 'T'
        'glyphicon glyphicon-earphone'
      else
        raise 'Unknown net'
    end
  end

  def station_net_to_icon(station_or_net, tag = :h1)
    content_tag tag, '', class: station_net_to_glyphicon(station_or_net), title: station_net_to_display_name(station_or_net)
  end

  def bootstrap_info(&block)
    content_tag :div, class: 'alert alert-info' do
      content_tag(:h3) do
        content_tag(:span, '', class: 'glyphicon glyphicon-info-sign') + ' informacja'
      end + content_tag(:p, capture( &block ))
    end
  end
end
