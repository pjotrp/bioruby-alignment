
module Bio
  module BioAlignment

    # Simple element that can be queried
    class Element
      GAP = '-'
      UNDEFINED = 'X'
      include State

      def initialize c
        @c = c
        @c.freeze
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
      def == other
        to_s == other.to_s
      end
    end

    # Elements is a container for Element sequences. 
    #
    class Elements
      include Enumerable
      include State

      attr_reader :id, :seq
      def initialize id, seq
        @id = id
        @id.freeze
        @seq = []
        if seq.kind_of?(Elements)
          @seq = seq.clone
        elsif seq.kind_of?(String)
          seq.each_char do |c|
            @seq << Element.new(c)
          end
        else
          seq.each do |s|
            @seq << Element.new(s)
          end
        end
      end

      def [] index
        @seq[index]
      end

      def length
        @seq.length
      end

      def each
        @seq.each { |e| yield e }
      end

      def to_s
        @seq.map{|e| e.to_s }.join("")
      end

      def << element
        @seq << element
      end

      def empty_copy
        Elements.new(@id,"")
      end

      def clone
        copy = Elements.new(@id,"")
        @seq.each do |e|
          copy << e.dup
        end
        copy
      end

    end
  end

end
