module Bio
 
  module BioAlignment

    module State
      attr_accessor :state
    end

    # Convenience class for tracking state. Note you can add
    # any class you like
    class ColumnState
      attr_accessor :deleted

      def deleted?
        deleted == true
      end
    end

    # Convenience class for tracking state. Note you can add
    # any class you like
    class RowState
      attr_accessor :deleted

      def deleted?
        deleted == true
      end
    end

  end

end
