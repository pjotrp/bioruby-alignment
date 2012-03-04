require 'bio-alignment/state'

module Bio
 
  module BioAlignment

    # The Columns module provides accessors for the column list
    # returning Column objects
    module Columns
     
      # Return a list of Column objects. The contents of the  
      # columns are accessed lazily
      def columns
        @columns ||= (0..num_columns-1).map { | col | Column.new(self,col) }
      end

      def num_columns
        p ["HERE",rows.first,rows.first.length]
        rows.first.length
      end
    end

    # Support the notion of columns in an alignment. A column
    # can have state by attaching state objects
    class Column
      include State

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

  end

end

