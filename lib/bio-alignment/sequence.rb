module Bio
  module BioAlignment

    # Simple element that can be queried
    class Element
      def initialize c
        @c = c
      end
      def gap?
        @c == '-'
      end
    end

    # A Sequence is a simple container for String sequences/lists
    #
    class Sequence
      include Enumerable

      attr_reader :id, :seq
      def initialize id, seq
        @id = id
        @seq = seq
      end

      def [] index
        @seq[index]
      end

      def each
        @seq.each_char { | c | yield Element.new(c) }
      end

      def to_s
        @seq.to_s
      end

    end
  end
end
