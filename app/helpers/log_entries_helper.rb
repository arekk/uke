module LogEntriesHelper
  def log_entries_distance_marker(distance, radius)
    case distance
      when 0..radius
        'success'
      when radius..(2*radius)
        'warning'
      else
        'danger'
    end
  end
end
