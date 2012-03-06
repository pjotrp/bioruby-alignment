module Bio
  module BioAlignment

    # Function for marking rows (sequences), when a row block returns the new
    # state, and returning a newly cloned alignment
    module MarkRows
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
  end
end

