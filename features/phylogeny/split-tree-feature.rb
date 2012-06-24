require 'bio-alignment/edit/tree_splitter.rb'

When /^I split the tree$/ do |string|
  tree = @aln.attach_tree(@tree)
  @aln.extend TreeSplitter
  (aln1,aln2) = @aln.split_on_distance
  # p "HERE",aln2,"",aln2
  # aln2.tree.output_newick(indent: false).should == "((seq6:5.3571434,(seq4:4.04762,((seq8:1.1904755,seq5:1.1904755):1.7857151,((seq3:0.0,seq2:0.0):1.1904755,seq1:1.1904755):1.7857151):1.0714293):1.3095236):4.336735);"
  aln2.size.should == @aln.size/2
end

When /^I split out branches with a maximum of (\d+) sequences from$/ do |arg1, string|
  pending # express the regexp above with the code you wish you had
end

Then /^I should have found "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I split out branches with a minimum of (\d+) and maximum of (\d+) sequences$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^I should have found sub\-trees "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I split the tree with a max of (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should have found low\-homology sub\-tree "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

