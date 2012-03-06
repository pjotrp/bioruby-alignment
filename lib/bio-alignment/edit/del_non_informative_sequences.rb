
module Bio
  module BioAlignment

    # Function for marking rows (sequences), when a row block returns the new
    # state, and returning a newly cloned alignment
    module MarkRow
      # Mark each seq
      def mark_rows &block
        aln = self.clone 
        # clone row state, or add a state object 
        aln.rows.each do | row |
          new_state =
            if row.state
              row.state.clone
            else
              RowState.new
            end
          row.state = block.call(new_state,row)
        end
        aln
      end
    end

    module DelNonInformativeSequences
      include MarkRow
   
      # Return a new alignment with rows marked for deletion, i.e. mark rows
      # that mostly contain undefined elements and gaps (threshold
      # +percentage+). The alignment returned is a cloned copy
      def mark_non_informative_sequences percentage = 30
        mark_rows { |state,row| 
          num = row.count { |e| e.gap? or e.undefined? }
          if (num.to_f/row.length) > 1.0-percentage/100.0
            state.delete!
          end
          state
        }
      end

      def del_non_informative_sequences percentage=30
        mark_non_informative_sequences.rows_where { |row| !row.state.deleted? }
      end
    end
  end
end
