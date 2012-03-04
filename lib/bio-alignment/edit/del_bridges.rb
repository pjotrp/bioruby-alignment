
module Bio
  module BioAlignment

    module DelBridges
   
      # Return a new alignment with columns marked for deletion, i.e. mark columns
      # that mostly contain gaps (threshold +percentage+)
      def mark_bridges percentage = 30
        aln = self.clone # not deep clone
        # clone column state as we are going to change that
        aln.columns.each_with_index do | column |
          new_state =
            if column.state
              column.state.clone
            else
              ColumnState.new
            end
          gap_num = column.count { |e| e.gap? }
          if (gap_num.to_f/rows.size) > 1.0-percentage/100.0
            new_state.delete!
          end
          column.state = new_state
        end
        aln
      end
    end
  end
end
