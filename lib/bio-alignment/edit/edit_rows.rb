module Bio
  module BioAlignment

    # Function for marking rows (sequences), when a row block returns the new
    # state, and returning a newly cloned alignment
    module MarkRows

      # Mark each seq
      def mark_rows &block
        aln = markrows_clone
        aln.rows.each do | row |
          row.state = block.call(row.state,row)
        end
        aln
      end

      def mark_row_elements &block
        aln = markrows_clone
      end

    protected 

      def markrows_clone
        aln = self.clone 
        # clone row state, or add a state object 
        aln.rows.each do | row |
          new_state =
            if row.state
              row.state.clone
            else
              RowState.new
            end
          row.state = new_state
        end
        aln
      end

    end
  end
end

