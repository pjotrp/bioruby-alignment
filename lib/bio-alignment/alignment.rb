# Alignment

module Bio
  module BioAlignment

    class Alignment
      include Enumerable

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
