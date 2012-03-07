
module Bio
  module BioAlignment

    module MaskElements
      def mask_with value
        self.clone
      end
    end

    # Simple element that can be queried
    class Element
      GAP = '-'
      UNDEFINED = 'X'

      def initialize c
        @c = c
      end
      def gap?
        @c == GAP
      end
      def undefined?
        @c == 'X'
      end
      def to_s
        @c
      end
    end

    # A Sequence is a simple and efficient container for String sequences. To
    # add state to elements unpack it into an Elements object with to_elements.
    #
    class Elements
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
