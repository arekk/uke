class DistinctFrequencies < ActiveRecord::Migration
  def up
    result = ActiveRecord::Base.connection.select_all "select mhz, group_concat(id) as ids, count(id) as num from frequencies group by mhz having num > 1 order by ids desc "
    result.rows.each do |row|
      frequencies_ids = row[1].split(',')                                                   # wszystkie idki
      first_frequency = Frequency.find(frequencies_ids.shift)                               # usuwamy pierwszą, w tablicy zostają duplikaty
      
      frequencies_ids.each do |frequency_id|                                                # iteruje po pozostałych czestotliwosciach
        FrequencyAssignment.where(frequency_id: frequency_id).each do |assignment|          # szukam wszystkich assignmentów dla danej czestotliwości
          assignment.frequency = first_frequency                                            # podmieniam na pierwszą znalezioną 
          assignment.save!
        end
        
        Frequency.delete(frequency_id)                                                      # moge już skasować
      end
    end
  end
end
