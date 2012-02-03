# Alignment

module Bio
  module BioAlignment

    class Alignment
      attr_accessor :sequences

      def initialize
        @sequences = []
      end

      alias rows sequences
    end
  end
end
