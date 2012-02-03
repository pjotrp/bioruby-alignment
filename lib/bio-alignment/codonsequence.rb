
module Bio
  module BioAlignment

    # Codon element for the matrix
    class Codon
      def initialize codon
        @codon = codon
      end

      def gap?
        @codon == '---'
      end

      def undefined?
      end

      def to_s
        @codon
      end
    end

    # A CodonSequence supports the concept of codons (triple
    # nucleotides) for an alignment
    #
    class CodonSequence
      attr_reader :id, :seq
      def initialize id, seq
        @id = id
        @seq = []
        seq.scan(/\S\S\S/).each do | codon |
          @seq << Codon.new(codon)
        end
      end
    end

  end
end
