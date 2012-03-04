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
      def to_s
        @c
      end
    end

    # A Sequence is a simple container for String sequences/lists
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

      def length
        @seq.length
      end

      def each
        @seq.each_char { | c | yield Element.new(c) }
      end

      def to_s
        map { |e| e.to_s }.join("")
      end

      def empty_copy
        obj = self.clone
        obj.empty_sequence!
        obj
      end

      def empty_sequence!
        @seq = []
      end

      def << element
        @seq << element
      end
    end
  end
end
