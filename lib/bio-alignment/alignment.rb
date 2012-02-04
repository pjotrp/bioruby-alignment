# Alignment

require 'bio-alignment/pal2nal'

module Bio
  module BioAlignment

    class Alignment
      include Enumerable
      include Pal2Nal

      attr_accessor :sequences

      def initialize
        @sequences = []
      end

      alias rows sequences

      def each
        rows.each { | seq | yield seq }
      end
    end
  end
end
