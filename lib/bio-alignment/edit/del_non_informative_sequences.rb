
module Bio
  module BioAlignment

    module DelNonInformativeSequences
   
      # Return a new alignment with rows marked for deletion, i.e. mark rows
      # that mostly contain undefined elements and gaps (threshold
      # +percentage+). The alignment returned is a cloned copy
      def mark_non_informative_sequences percentage = 30
        aln = self.clone 
        # clone row state 
        aln.rows.each do | row |
          new_state =
            if row.state
              row.state.clone
            else
              RowState.new
            end
          num = row.count { |e| e.gap? or e.undefined? }
          if (num.to_f/row.length) > 1.0-percentage/100.0
            new_state.delete!
          end
          row.state = new_state
        end
        aln
      end

      def del_non_informative_sequences percentage=30
        mark_non_informative_sequences.rows_where { |row| !row.state.deleted? }
      end
    end
  end
end
