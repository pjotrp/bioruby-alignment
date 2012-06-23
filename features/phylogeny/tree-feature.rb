require 'bio'  # for the Newick tree parser
require 'bio-alignment'

Given /^I have a multiple sequence alignment \(MSA\)$/ do |string|
  list = string.split(/\n/) 
  seqs = list.map { | line | line.split('  ')[1] }
  ids = list.map { | line | line.split('  ')[0] }
  @aln = Alignment.new(seqs, ids)
  print @aln
end

Given /^I have a phylogenetic tree in Newick format$/ do |string|
  @tree = Bio::Newick.new(string).tree
  tree = @tree
  tree.children(tree.root).size.should == 2
  tree.descendents(tree.root).size.should == 14
  tree.leaves.size.should == 8
  leaf = tree.get_node_by_name('seq8')
  leaf.name.should == "seq8"
  tree.ancestors(leaf).size.should == 5
  tree.get_edge(leaf, tree.parent(leaf)).distance.should == 1.1904755
  tree.get_edge(tree.parent(leaf), tree.parent(tree.parent(leaf))).distance.should == 1.7857151
end

Then /^I should be able to traverse the tree$/ do
  tree = @aln.attach_tree(@tree)
  root = @aln.root # get the root of the tree
  root.leaf?.should == false
  children = root.children
  # root has one direct leaf
  children.map { |n| n.name }.sort.should == ["","seq7"]
  seq7 = children.last
  seq7.name.should == 'seq7'
  seq7.leaf?.should == true
  seq7.parent.should == root
  # find leaf seq4
  seq4 = tree.find("seq4")
  seq4.leaf?.should == true
  # total distance to seq7 9.69+4.34+1.31+4.05 ~ 19.38
  seq4.distance(seq7).should == 19.387756600000003  # BioRuby does this!
end

Then /^fetch elements from the MSA from each end node in the tree$/ do
  # walk the tree
  tree = @aln.attach_tree(@tree)
  ids = []
  # Walk the ordered tree and fetch the sequence from the alignment
  column20 = tree.map { | leaf |
    ids << leaf.name
    # we have the ID, now find the alignment
    seq = @aln.find(leaf.name) 
    # Return the 18th nucleotide, just for show
    seq[19]
  }
  ids.should == ["seq6", "seq4", "seq8", "seq5", "seq3", "seq2", "seq1", "seq7"]
  column20.should == ["K", "T", "K", "K", "T", "T", "T", "K"]
end

Then /^calculate the phylogenetic distance between each element$/ do
  # we did this earlier with
  tree = @aln.attach_tree(@tree)
  seq7 = tree.find("seq7")
  seq4 = tree.find("seq4")
  # total distance to seq7 9.69+4.34+1.31+4.05 ~ 19.38
  seq4.distance(seq7).should == 19.387756600000003  # BioRuby does this!
end

Then /^find that the nearest sequence to "([^"]*)" is "([^"]*)"$/ do |arg1, arg2|
  tree = @aln.attach_tree(@tree)
  seq = tree.find(arg1)
  p arg2
  seq.siblings.join(',').should == arg2
end

Then /^find that "([^"]*)" is on the same branch as "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end


Then /^draw the MSA with the tree$/ do | string |
  # textual drawing, like tabtree, or http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/149701
  # or BioPythons http://biopython.org/DIST/docs/api/Bio.Phylo._utils-pysrc.html#draw_ascii
  # hg clone https://bitbucket.org/keesey/namesonnodes-sa
  #
  # http://cegg.unige.ch/newick_utils
  # http://code.google.com/p/a3lbmonkeybrain-as3/source/browse/trunk/src/a3lbmonkeybrain/calculia/collections/graphs/exporters/TextCladogramExporter.as?spec=svn26&r=26
  print string
  pending # express the regexp above with the code you wish you had
end

Then /^draw MSA with the short tree$/ do |string|
  pending # express the regexp above with the code you wish you had
end
