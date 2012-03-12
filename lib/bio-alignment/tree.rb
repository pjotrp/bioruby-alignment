module Bio

  module BioAlignment

    # The Tree module turns a tree into a traversable object, by wrapping
    # BioRuby's basic tree objects. The Bio::Tree object can always be
    # fetched using to_bioruby_tree.

    module Tree

      class Node
      end

      def Tree::init tree
        if tree.kind_of?(Bio::Tree)
          # walk all nodes and add the tree info
          tree.each_node do | node |
            node.set_tree(tree)
          end
          tree.root.set_tree(tree)
          return tree
        else
          raise "BioAlignment::Tree does not understand tree type "+tree.class.to_s
        end
      end

      def root
        @tree.root
      end

    end

  end

  # Here we add to BioRuby's Bio::Tree classes
  class Tree
    class Node
      def set_tree tree
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
