module Bio
  module BioAlignment

    module MarkColumns
      def mark_columns &block
        aln = self.clone 
        # clone column state
        aln.columns.each do | column |
          new_state =
            if column.state
              column.state.clone
            else
              ColumnState.new
            end
          column.state = block.call(new_state,column)
        end
        aln
      end
    end
  end
end

