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
        # Start from the root of the tree (FIXME: what if there is no root?)
        new_root = aln1.tree.root
        branch = nil
        while new_root
          # find the nearest child (shortest edge)
          near_children = new_root.nearest_children
          # We have multiple matches, so we are going to split on the 
          # number of leafs, or we leave it like it is, if the split 
          # will be too far from the target
          new_root = near_children.first
          near_children.each do |c|
            next if c == new_root
            # find the nearest match
            if (c.leaves.size-target_size).abs < (new_root.leaves.size-target_size).abs
              new_root = c 
            end
          end
          branch = aln1.tree.clone_subtree(new_root)
          # p [branch.leaves.size,target_size]
          # Break out of the loop when we hit the target
          break if branch.leaves.size <= target_size 
        end
        reduced_tree = aln1.tree.clone_tree_without_branch(new_root)
        # p branch.map { |n| n.name }.compact
        # p reduced_tree.map { |n| n.name }.compact

        # Now reduce the alignments themselves to match the trees
        aln1 = tree_reduce(reduced_tree)
        aln2 = tree_reduce(branch)
        return aln1,aln2
      end

    end
  end
end

