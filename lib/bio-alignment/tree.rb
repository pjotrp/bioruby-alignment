module Bio

  module BioAlignment

    # The Tree module turns a tree into a traversable object, by wrapping
    # BioRuby's basic tree objects. The Bio::Tree object can always be
    # fetched using to_bioruby_tree.

    module Tree

      class Node
      end

      # Make all nodes in the Bio::Tree aware of the tree object so we can use
      # its methods
      def Tree::init tree
        if tree.kind_of?(Bio::Tree)
          # walk all nodes and infect the tree info
          tree.each_node do | node |
            node.inject_tree(tree)
          end
          # tree.root.set_tree(tree)
        else
          raise "BioAlignment::Tree does not understand tree type "+tree.class.to_s
        end
        return tree
      end

      def root
        @tree.root
      end

    end

  end

  # Here we add to BioRuby's Bio::Tree classes
  class Tree
    class Node
      def inject_tree tree
        @tree = tree
      end

      def leaf?
        children.size == 0
      end

      def children
        @tree.children(self)
      end

      def parent
        @tree.parent(self)
      end
    end
  end
end
