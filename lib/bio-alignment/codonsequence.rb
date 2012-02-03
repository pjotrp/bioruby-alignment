
require 'bio'

module Bio
  module BioAlignment

    CODON_TABLE = Bio::CodonTable[1]  # BioRuby Eukaryote table

    # Codon element for the matrix
    class Codon
      def initialize codon
        @codon = codon
      end

      def gap?
        @codon == '---'
      end

      def undefined?
        aa = CODON_TABLE[@codon]
        if aa == nil and not gap?
          return true
        end
        false
      end

      def to_s
        @codon
      end

      # lazily convert to Amino acid (once only)
      def to_aa
        @aa ||= CODON_TABLE[@codon]
        if not @aa 
          if gap?
            return '-'
          elsif undefined?
            return 'X'
          else
            raise 'What?'
          end
        end
        @aa
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

      def [] index
        @seq[index]
      end

      def to_s
        @seq.map { |codon| codon.to_s }.join(' ')
      end
    end

  end
end
