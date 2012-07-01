module Bio
  module BioAlignment

    # A Sequence is a simple and efficient container for String sequences. To
    # add state to elements unpack it into an Elements object with to_elements.
    #
    class Sequence
      include Enumerable
      include State

      attr_reader :id, :seq
      def initialize id, seq
        @id = id
        @seq = seq
      end

      def [] index
        @seq[index]
      end

      # def []= index, value
      #   @seq[index] = value
      # end

      def length
        @seq.length
      end

      # Return each element in the Sequence as an Element opbject, so it
      # can be queried for gap? and undefined?
      def each
        @seq.each_char { | c | yield Element.new(c) }
      end

      def to_s
        @seq.to_s
      end

      def << element
        @seq += element.to_s
      end

      def empty_copy
        Sequence.new(@id,"")
      end

      def clone
        Sequence.new(@id,@seq.clone)
      end

      # Return Sequence (string) as an Elements object
      def to_elements
        Elements.new(@id,@seq)
      end
    end
  end
end
