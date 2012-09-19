module Bio
  # Here we override BioRuby Sequence classes, so they are enumerable
  class Sequence
    class NA
      include Enumerable
      def each
        to_s.each_char do | c | 
          yield c
        end
      end
    end
    class AA
      include Enumerable
      def each
        to_s.each_char do | c |
          yield c
        end
      end
    end
  end

  # Here we add a BioRuby converter
  module BioAlignment
    class Alignment
      def to_bioruby_alignment
        Bio::Alignment.new(self)
      end
    end
  end
end

