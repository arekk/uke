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
    simple_format list.map{|frequency| number_with_precision(frequency.mhz, :precision => 4)}.join("\n")
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
end
