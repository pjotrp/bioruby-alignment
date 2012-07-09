module Bio
  module BioAlignment

    # Function for marking rows (sequences), when a row block returns the new
    # state, and returning a newly cloned alignment
    module MarkRows

      # Mark each seq and return alignment
      def mark_rows &block
        aln = markrows_clone
        aln.rows.each do | row |
          row.state = block.call(row.state,row)
        end
        aln
      end

      # allow the marking of elements in a copied alignment, making sure 
      # each element is a proper Element object that can contain state.
      #
      # A Sequence alignment will be turned into an Elements alignment.
      #
      # Returns the new alignment
      def mark_row_elements &block
        aln = markrows_clone
        aln.rows.each_with_index do | row,rownum |
          new_seq = block.call(Coerce::to_elements(row),rownum)
          p [rownum,new_seq,row]
          aln.rows[rownum] = new_seq
        end
        aln
      end

    protected 

      def markrows_clone
        aln = self.clone 
        # clone row state, or add a state object 
        aln.rows.each do | row |
          if row.respond_to?(:state)
            new_state =
              if row.state
                row.state.clone
              else
                RowState.new
              end
            row.state = new_state
          end
        end
        aln
      end

    end
  end
end

