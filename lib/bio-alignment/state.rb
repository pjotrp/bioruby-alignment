module Bio
 
  module BioAlignment

    module State
      attr_accessor :state
    end

    module DeleteState
      attr_accessor :deleted

      def delete!
        @deleted = true
      end

      def deleted?
        @deleted == true
      end

      def to_s
        (deleted? ? 'X' : '.')
      end
    end

    module MarkState
      attr_accessor :marked

      def mark!
        @marked = true
      end

      def unmark!
        @marked = false
      end

      def marked?
        @marked == true
      end

      def to_s
        (marked? ? 'X' : '.')
      end
    end

    module MaskState
      attr_accessor :masked

      def mask!
        @masked = true
      end

      def unmask!
        @masked = false
      end

      def masked?
        @masked == true
      end

      def to_s
        (masked? ? 'X' : '.')
      end
    end

    # Convenience class for tracking state. Note you can add
    # any class you like
    class ColumnState
      include DeleteState
    end

    # Convenience class for tracking state. Note you can add
    # any class you like
    class RowState
      include DeleteState
    end

    class ElementState
      include MarkState
    end

    class ElementMaskedState
      include MaskState
    end

  end

end
