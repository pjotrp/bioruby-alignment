require 'bio-alignment/edit/tree_splitter.rb'

When /^I split the tree$/ do |string|
  tree = @aln.attach_tree(@tree)
  @aln.extend TreeSplitter
  (aln1,aln2) = @aln.split_on_distance
  aln2.size.should == 5
  @split1 = aln1
  @split2 = aln2
end

Then /^I should have found sub\-trees "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  @split2.names.join(",").should == arg2
  @split1.names.join(",").should == arg1
end


Then /^I should have found low\-homology sub\-tree "([^"]*)"$/ do |arg1|
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

When /^I split the tree with a max of (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end


