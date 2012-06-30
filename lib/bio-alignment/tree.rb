module Bio

  module BioAlignment

    # The Tree module turns a tree into a traversable object, by wrapping
    # BioRuby's basic tree objects. The Bio::Tree object can always be
    # fetched using to_bioruby_tree.

    module Tree

      class Node
      end

      # Make all nodes in the Bio::Tree aware of the tree object, and the alignment, so
      # get a more intuitive API
      def Tree::init tree, alignment
        if tree.kind_of?(Bio::Tree)
          # walk all nodes and infect the tree info
          tree.each_node do | node |
            node.inject_tree(tree, alignment)
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
      def inject_tree tree, alignment
        @tree = tree
        @alignment = alignment
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

      def descendents
        @tree.descendents(self)
      end

      # Get the parents of this Node
      def parent
        @tree.parent(self)
      end

      # Get the direct sibling nodes (i.e. parent.children)
      def siblings
        parent.children - [self]
      end

      # Return the leaves of this node
      def leaves
        @tree.leaves(self)
      end

      # Find the nearest and dearest, i.e. the leafs attached to the parent
      # node
      def nearest
        @tree.leaves(parent) - [self]
      end
  
      # Get the distance to another node
      def distance other
        @tree.distance(self,other)
      end

      # Get child node with the shortest edge - note that if there are more
      # than one, the first will be picked
      def nearest_child
        c = nil
        children.each do |n|
          c=n if not c or distance(n)<distance(c)
        end
        c
      end

      # Get the child nodes with the shortest edge - returns an Array
      def nearest_children
        min_distance = distance(nearest_child)
        cs = []
        children.each do |n|
          cs << n if distance(n) == min_distance
        end
        cs
      end

      # Return the alignment attached to the tree
      def alignment
        @alignment
      end

      def sequence
        @alignment.find(name)
      end
    end  # End of injecting Node functionality

    def find name
      get_node_by_name(name)
    end

    # Walk the ordered tree leaves, calling into the block, and return an array 
    def map 
      leaves.map { | leaf | yield leaf }
    end

    # Create a deep clone of the tree
    def clone_subtree start_node 
      new_tree = self.class.new
      list = [start_node] + start_node.descendents
      list.each do |x|
        new_tree.add_node(x)
      end
      each_edge do |node1, node2, edge|
        if new_tree.include?(node1) and new_tree.include?(node2) 
          new_tree.add_edge(node1, node2, edge)
        end
      end
      new_tree
    end

    # Clone a tree without the branch starting at node
    def clone_tree_without_branch node
      new_tree = self.class.new
      original = [root] + root.descendents
      # p "Original",original
      skip = [node] + node.descendents
      # p "Skip",skip
      # p "Retain",root.descendents - skip
      nodes.each do |x|
        if not skip.include?(x)
          new_tree.add_node(x) 
        else
        end
      end
      each_edge do |node1, node2, edge|
        if new_tree.include?(node1) and new_tree.include?(node2) 
          new_tree.add_edge(node1, node2, edge)
        end
      end
      new_tree
    end

    def clone
      new_tree = self.class.new
      nodes.each do |x|
        new_tree.add_node(x)
      end
      self.each_edge do |node1, node2, edge|
        if new_tree.include?(node1) and new_tree.include?(node2) then
          new_tree.add_edge(node1, node2, edge)
        end
      end
      new_tree
    end

  end
end
