module Bio
  module BioAlignment

    # Split an alignment based on its phylogeny
    module TreeSplitter

      # Split an alignment using a phylogeny tree.  One half contains sequences
      # that are relatively homologues, the other half contains the rest. This
      # is described in the tree-split.feature in the features directory. 
      #
      # The target_size parameter gives the size of the homologues sequence
      # set. If target_size is nil, the set will be split in half.
      #
      # Returns two alignments with their matching trees attached
      def split_on_distance target_size = nil
        aln = clone
        target_size = aln.size/2 if not target_size
        tree = aln.tree
        aln1 = aln
        aln2 = aln
        print aln1.tree.output_newick(indent: false)
        return aln1,aln2
      end

    end
  end
end

