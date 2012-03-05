
module Bio
  module BioAlignment

    module DelShortSequences
   
      # Return a new alignment with rows marked for deletion, i.e. mark
      # rows that mostly contain gaps (threshold +percentage+). The 
      # alignment returned is a cloned copy
      def mark_short_sequences percentage = 30
        aln = self.clone # not so deep clone
        # clone row state as we are going to change that
        aln.rows.each do | row |
          new_state =
            if row.state
              row.state.clone
            else
              rowState.new
            end
          gap_num = row.count { |e| e.gap? }
          if (gap_num.to_f/rows.size) > 1.0-percentage/100.0
            new_state.delete!
          end
          row.state = new_state
        end
        # p self.rows[0].state
        # p aln.rows[0].state
        aln
      end

      # Return an alignment with the bridges removed
      def del_short_sequences percentage=30
        mark_bridges.rows_where { |col| !col.state.deleted? }
      end
    end
  end
end
