require 'bio-alignment/edit/edit_columns'

module Bio
  module BioAlignment

    module DelBridges
      include MarkColumns
   
      # Return a new alignment with columns marked for deletion, i.e. mark
      # columns that mostly contain gaps (threshold +percentage+). The 
      # alignment returned is a cloned copy
      def mark_bridges percentage = 30
        mark_columns { |state,column| 
          num = column.count { |e| e.gap? or e.undefined? }
          if (num.to_f/column.length) > 1.0-percentage/100.0
            state.delete!
          end
          state
        }
      end

      # Return an alignment with the bridges removed
      def del_bridges percentage=30
        mark_bridges.columns_where { |col| !col.state.deleted? }
      end
    end
  end
end
