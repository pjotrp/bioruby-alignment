# Alignment

require 'bio-alignment/pal2nal'
require 'bio-alignment/columns'
require 'bio-alignment/rows'

module Bio
 
  module BioAlignment

    class Alignment
      include Enumerable
      include Pal2Nal
      include Rows
      include Columns
      include Coerce

      attr_accessor :sequences
      attr_reader :tree

      # Create alignment. seqs can be a list of sequences. If these
      # are String types, they get converted to the library Sequence 
      # container
      def initialize seqs = nil, ids = nil
        @sequences = []
        if seqs 
          num = 0
          seqs.each_with_index do | seq, i |
            next if seq == nil or seq.to_s.strip == ""
            id = num
            id = ids[i] if ids and ids[i]
            @sequences << 
              if seq.kind_of?(String)
                seq1 = Sequence.new(id,seq.strip)
                seq1
              else
                seq
              end
            num += 1
          end
        end
      end

      alias rows sequences

      # return an array of sequence ids
      def ids
        rows.map { |r| Coerce::fetch_id(r) }
      end

      def size
        rows.size
      end

      # Return a sequence by index
      def [] index
        rows[index]
      end

      def << seq
        @sequences << seq
      end

      def each
        rows.each { | seq | yield seq }
        self
      end

      def each_element
        each { |seq| seq.each { |e| yield e }}
        self
      end

      def find name
        each do | seq |
          return seq if Coerce::fetch_id(seq) == name
        end
        raise "ERROR: Sequence not found by its name, looking for <#{name}>"
      end
     
      # copy alignment and allow updating elements. Returns alignment.
      def update_each_element
        aln = self.clone
        aln.each { |seq| seq.each_with_index { |e,i| seq.seq[i] = yield e }}
      end

      def to_s
        res = ""
        res += "\t" + columns_to_s + "\n" if @columns
        # fetch each sequence in turn
        res += map{ |seq| Coerce::fetch_id(seq).to_s + "\t" + Coerce::fetch_seq_string(seq) }.join("\n")
        res
      end

      # Return a deep cloned alignment. This method clones sequences,
      # and the state objects
      def clone
        aln = super
        # clone the sequences
        aln.sequences = []
        each do | seq |
          aln.sequences << seq.clone
        end
        aln.clone_columns! if @columns
        # clone the tree
        @tree = @tree.clone if @tree
        aln
      end

      # extend BioAlignment with Tree functionality - this method adds 
      # a tree and pulls in the functionality of the Tree module. Returns
      # the tree traverser
      def attach_tree tree
        extend Tree
        @tree = Tree::init(tree,self)
        @tree
      end

      # Reduce an alignment, based on the new tree
      def tree_reduce new_tree
        names = new_tree.map { | node | node.name }.compact
        # p names
        nrows = []
        names.each do | name |
          nrows << find(name).clone
        end
        new_aln = Alignment.new(nrows)
        new_aln.attach_tree(new_tree.clone)
        new_aln
      end

    end
  end
end
