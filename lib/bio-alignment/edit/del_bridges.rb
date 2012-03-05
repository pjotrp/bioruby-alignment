
module Bio
  module BioAlignment

    module DelBridges
   
      # Return a new alignment with columns marked for deletion, i.e. mark
      # columns that mostly contain gaps (threshold +percentage+). The 
      # alignment returned is a cloned copy
      def mark_bridges percentage = 30
        aln = self.clone # deep clone
        # clone column state
        aln.columns.each do | column |
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
        # p self.columns[0].state
        # p aln.columns[0].state
        aln
      end

      # Return an alignment with the bridges removed
      def del_bridges percentage=30
        mark_bridges.columns_where { |col| !col.state.deleted? }
      end
    end
  end
end
