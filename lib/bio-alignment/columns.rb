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

      # Return an alignment which match columns. The originating
      # sequences should have methods 'empty_copy' and '<<'
      def columns_where &block
        seqs = []
        rows.each do | seq | 
          new_seq = seq.empty_copy
          seq.each_with_index do | e,i |
            new_seq << e if block.call(columns[i])
          end
          seqs << new_seq
        end
        Alignment.new(seqs)
      end

      def columns_to_s
        columns.map { |c| (c.respond_to?(:state) ? c.state.to_s : '?') }.join
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

    # Support the notion of columns in an alignment. A column is simply an
    # integer index into the alignment, stored in @col. A column can have state
    # by attaching state objects.
    class Column
      include State
      include Enumerable

      def initialize aln, col
        @aln = aln
        @col = col # column index number
      end

      def [] index
        @aln[index][@col] 
      end

      # update all elements in the column
      # def update! new_column
      #   each_with_index do |e,i|
      #     @aln[i][@col] = new_column[i]
      #   end
      # end

      # iterator fetches a column on demand, yielding column elements
      def each
        @aln.each do | seq |
          yield seq[@col]
        end
      end

      def length
        @length ||= @aln.rows.size
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

      def to_s
        map{|e| e.to_s}.join('')
      end

    end

  end

end

