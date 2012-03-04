# Alignment

require 'bio-alignment/pal2nal'
require 'bio-alignment/column'

module Bio
 
  module BioAlignment

    class Alignment
      include Enumerable
      include Pal2Nal
      include Columns

      attr_accessor :sequences

      # Create alignment. seqs can be a list of sequences. If these
      # are String types, they get converted to the library Sequence 
      # container
      def initialize seqs = nil
        @sequences = []
        if seqs 
          i = 0
          seqs.each do | seq |
            next if seq == nil or seq.to_s.strip == ""
            @sequences << 
              if seq.kind_of?(String)
                Sequence.new(i,seq)
              else
                seq
              end
            i += 1
          end
        end
      end

      alias rows sequences

      def [] index
        rows[index]
      end

      def each
        rows.each { | seq | yield seq }
      end

      def to_s
        map { | seq | seq.to_s }.join("\n")
      end

    end
  end
end
