require 'bio-alignment/edit/edit_rows'

module Bio
  module BioAlignment

    module DelShortSequences
      include MarkRows
   
      # Return a new alignment with rows marked for deletion, i.e. mark
      # rows that mostly contain gaps (threshold +percentage+). The 
      # alignment returned is a cloned copy
      def mark_short_sequences percentage = 30
        mark_rows { |state,row| 
          num = row.count { |e| e.gap? }
          if (num.to_f/row.length) > 1.0-percentage/100.0
            state.delete!
          end
          state
        }
      end

      # Return an alignment with the bridges removed
      def del_short_sequences percentage=30
        mark_short_sequences.rows_where { |row| !row.state.deleted? }
      end
    end
  end
end
