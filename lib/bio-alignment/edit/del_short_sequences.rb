
module Bio
  module BioAlignment

    module DelShortSequences
   
      # Return a new alignment with rows marked for deletion, i.e. mark
      # rows that mostly contain gaps (threshold +percentage+). The 
      # alignment returned is a cloned copy
      def mark_short_sequences percentage = 30
        aln = self.clone 
        # clone row state 
        aln.rows.each do | row |
          new_state =
            if row.state
              row.state.clone
            else
              RowState.new
            end
          gap_num = row.count { |e| e.gap? }
          if (gap_num.to_f/row.length) > 1.0-percentage/100.0
            new_state.delete!
          end
          row.state = new_state
        end
        aln
      end

      # Return an alignment with the bridges removed
      def del_short_sequences percentage=30
        mark_short_sequences.rows_where { |row| !row.state.deleted? }
      end
    end
  end
end
