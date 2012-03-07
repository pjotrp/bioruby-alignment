
module Bio
  module BioAlignment

    module Elements
      def mask_with value
        self.clone
      end
    end

    # Simple element that can be queried
    class Element
      GAP = '-'
      UNDEFINED = 'X'

      def initialize c
        @c = c
      end
      def gap?
        @c == GAP
      end
      def undefined?
        @c == 'X'
      end
      def to_s
        @c
      end
    end

  end

end
