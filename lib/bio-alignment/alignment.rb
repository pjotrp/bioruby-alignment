# Alignment

require 'bio-alignment/pal2nal'

module Bio
 
  module BioAlignment

    class Alignment
      include Enumerable
      include Pal2Nal

      attr_accessor :sequences

      # Create alignment. seqs can be a list of sequences. If these
      # are String types, they get converted to the library Sequence 
      # container
      def initialize seqs = nil
        @sequences = []
        if seqs 
          seqs.each_with_index do | seq, i |
            @sequences << 
              if seq.kind_of?(String)
                Sequence.new(i,seq)
              else
                seq
              end
          end
        end
      end

      alias rows sequences

      # def [] index  <- need matrix
      #   rows[index]
      # end

      def each
        rows.each { | seq | yield seq }
      end
    end
  end
end
