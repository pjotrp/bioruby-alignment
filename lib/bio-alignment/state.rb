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

  end

end
