module Bio
  # Here we override BioRuby Sequence classes, so they are enumerable
  class Sequence
    class NA
      include Enumerable
      def each
        to_s.each_byte do | c |
          yield c
        end
      end
    end
    class AA
      include Enumerable
      def each
        to_s.each_byte do | c |
          yield c
        end
      end
    end
  end
end

