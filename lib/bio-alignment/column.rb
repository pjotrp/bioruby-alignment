module Bio
 
  module BioAlignment

    # The Columns module provides accessors for the column list
    # returning Column objects
    module Columns
     
      # Return a list of Column objects. The contents of the  
      # columns are accessed lazily
      def columns
        (0..num_columns-1).map { | col | Column.new(self,col) }
      end

      def num_columns
        rows.first.length
      end
    end

    # Support the notion of columns in an alignment. A column
    # can have state by attaching state objects
    class Column
      attr_accessor :state

      def initialize aln, col
        @aln = aln
        @col = col
      end

      def [] index
        @aln[index][@col] 
      end

      # iterator fetches a column on demand
      def each
        @aln.each do | seq |
          yield seq[@col]
        end
      end
    end

    # Convenience class for tracking state. Note you can add
    # any class you like
    class ColumnState
      attr_accessor :deleted

      def deleted?
        deleted == true
      end
    end
  end

end

