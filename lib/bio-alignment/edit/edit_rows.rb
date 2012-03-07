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

      # allow the marking of elements in a copied alignment, making sure 
      # each element is a proper Element object that can contain state.
      # A Sequence alignment will be turned into an Elements alignment.
      def mark_row_elements &block
        aln = markrows_clone
        aln.rows.each_with_index do | row,i |
          new_seq = block.call(row.to_elements)
          aln.rows[i] = new_seq
        end
        aln
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

