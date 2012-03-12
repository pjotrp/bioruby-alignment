require 'bio'  # for the Newick tree parser
require 'bio-alignment'

Given /^I have a multiple sequence alignment \(MSA\)$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
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
  # @aln.extend AlignmentTree
  pending # express the regexp above with the code you wish you had
end

Then /^fetch elements from the MSA from each end node in the tree$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^calculate the phylogenetic distance between each element$/ do
  pending # express the regexp above with the code you wish you had
end

