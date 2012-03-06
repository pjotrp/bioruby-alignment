
require 'bio'

module Bio
  module BioAlignment

    # Codon element for the matrix, used by CodonSequence.
    class Codon
      GAP = '---'
      UNDEFINED = 'X'

      attr_reader :codon_table

      def initialize codon, codon_table = 1
        @codon = codon
        @codon_table = codon_table
      end

      def gap?
        @codon == GAP
      end

      def undefined?
        aa = translate
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
        aa = translate
        if not aa
          if gap?
            return '-'
          elsif undefined?
            return UNDEFINED
          else
            raise 'What?'
          end
        end
        aa
      end

    private

      # lazy translation of codon to amino acid
      def translate
        @aa ||= Bio::CodonTable[@codon_table][@codon]
        @aa
      end
    end

    # A CodonSequence supports the concept of codons (triple
    # nucleotides) for an alignment. A codon table number can be passed
    # in for translation of nucleotide sequences. This is the same 
    # table used in BioRuby.
    #
    class CodonSequence
      include Enumerable

      attr_reader :id, :seq
      def initialize id, seq, options = { :codon_table => 1 }
        @id = id
        @seq = []
        @codon_table = options[:codon_table]
        seq.scan(/\S\S\S/).each do | codon |
          @seq << Codon.new(codon, @codon_table)
        end
      end

      def [] index
        @seq[index]
      end

      def length
        @seq.length
      end

      def each
        @seq.each { | codon | yield codon }
      end

      def to_s
        @seq.map { |codon| codon.to_s }.join(' ')
      end

      # extra methods

      def to_nt
        @seq.map { |codon| codon.to_s }.join('')
      end
        
      def to_aa
        @seq.map { |codon| codon.to_aa }.join('')
      end

      def empty_copy
        CodonSequence.new(@id,"")
      end

      def << codon
        @seq << codon
      end
        
    end

  end
end
