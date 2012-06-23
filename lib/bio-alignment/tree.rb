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
      # Add tree information to this node, so it can be queried 
      def inject_tree tree
        @tree = tree
        self
      end

      # Is this Node a leaf?
      def leaf?
        children.size == 0
      end

      # Get the children of this Node
      def children
        @tree.children(self)
      end

      # Get the parents of this Node
      def parent
        @tree.parent(self)
      end

      # Get the direct sibling nodes (i.e. parent.children)
      def siblings
        parent.children - [self]
      end

      # Find the nearest and dearest, i.e. the leafs attached to the parent
      # node
      def nearest
        @tree.leaves(parent) - [self]
      end
  
      # Get the distance to another node (FIXME: write test)
      def distance other
        @tree.distance(self,other)
      end
    end  # End of injecting Node functionality

    def find name
      get_node_by_name(name)
    end

    # Walk the ordered tree leaves, calling into the block, and return an array 
    def map 
      res = []
      leaves.each do | leaf |
        item = yield leaf
        res << item
      end
      res
    end

  end
end
