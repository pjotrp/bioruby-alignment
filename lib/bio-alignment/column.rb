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

      # def columns= list
      #   @columns = list
      # end

      def num_columns
        rows.first.length
      end

      def columns_to_s
        columns.map { |c| (c.state ? c.state.to_s : '?') }.join
      end
       
      def clone_columns!
        # clone the columns
        old_columns = @columns
        @columns = []
        old_columns.each do | old_column |
          @columns << old_column.clone
        end
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

