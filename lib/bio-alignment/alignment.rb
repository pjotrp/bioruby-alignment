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

      attr_accessor :sequences

      # Create alignment. seqs can be a list of sequences. If these
      # are String types, they get converted to the library Sequence 
      # container
      def initialize seqs = nil
        @sequences = []
        if seqs 
          i = 0
          seqs.each do | seq |
            next if seq == nil or seq.to_s.strip == ""
            @sequences << 
              if seq.kind_of?(String)
                Sequence.new(i,seq.strip)
              else
                seq
              end
            i += 1
          end
        end
      end

      alias rows sequences

      def [] index
        rows[index]
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
          return seq if seq.id == name
        end
        raise "ERROR: Sequence not found by its name #{name}"
      end
     
      # clopy alignment and allow updating elements
      def update_each_element
        aln = self.clone
        aln.each { |seq| seq.each_with_index { |e,i| seq.seq[i] = yield e }}
      end

      def to_s
        res = ""
        res += "\t" + columns_to_s + "\n" if @columns
        res += map{ |seq| seq.id.to_s + "\t" + seq.to_s }.join("\n")
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
        aln
      end

      # extend BioAlignment with Tree functionality - this method adds 
      # a tree and pulls in the functionality of the Tree module. Returns
      # the tree traverser
      def link_tree tree
        extend Tree
        @tree = Tree::init(tree)
        @tree
      end
    end
  end
end
