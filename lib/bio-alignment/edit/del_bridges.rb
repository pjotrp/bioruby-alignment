
module Bio
  module BioAlignment

    module DelBridges
   
      # Mark all columns for deletion that mostly contain
      # gaps (threshold +percentage+) and return the 
      # alignment with updated columns
      def mark_del_bridges percentage = 30
      end

      # Return an alignment with the columns removed that mostly contain
      # gaps (threshold +percentage). Returns a tuple of the new alignment,
      # and a list of column objects marked for deletion
      def del_bridges percentage = 30
        aln = self
        p aln.columns.size
        aln.columns.each do | column |
          p column[1]
        end
        return self, "test"
      end
    end
  end
end
