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
        target_size = size/2+1 if not target_size

        aln1 = clone
        new_root = aln1.tree.root
        branch = nil
        while new_root
          new_root = new_root.nearest_child
          branch = aln1.tree.clone_subtree(new_root)
          # p [branch.leaves.size,target_size]
          break if branch.leaves.size <= target_size 
        end
        reduced_tree = aln1.tree.clone_tree_without_branch(new_root)
        # p branch.map { |n| n.name }.compact
        # p reduced_tree.map { |n| n.name }.compact

        # Now reduce the alignments themselves
        aln1 = tree_reduce(reduced_tree)
        aln2 = tree_reduce(branch)
        return aln1,aln2
      end

    end
  end
end

