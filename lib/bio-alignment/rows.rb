require 'bio-alignment/state'

module Bio
 
  module BioAlignment

    # The Rows module provides accessors for the Row list
    # returning Row objects
    module Rows
     
      # Return an copy of an alignment which matching rows. The originating
      # sequences should have methods 'empty_copy' and '<<'
      def rows_where &block
        seqs = []
        rows.each do | seq | 
          seqs << seq.clone if block.call(seq)
        end
        Alignment.new(seqs)
      end

    end

    # Support the notion of Rows in an alignment. A Row
    # can have state by attaching state objects
    class Row
      include State

      def initialize aln, row
        @aln = aln
        @row = row
      end

      def count &block
        counter = 0
        each do | e |
          found = 
            if e.kind_of?(String)
              block.call(Element.new(e))
            else
              block.call(e)
            end
          counter += 1 if found
        end
        counter
      end

    end

  end

end

