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
  @split2.ids.sort.join(",").should == arg2
  @split1.ids.sort.join(",").should == arg1
end

When /^I split the tree with a target of (\d+)$/ do |arg1|
  tree = @aln.attach_tree(@tree)
  @aln.extend TreeSplitter
  @split1,@split2 = @aln.split_on_distance(arg1.to_i)
end

Then /^I should have found low\-homology sub\-tree "([^"]*)"$/ do |arg1|
  @split1.ids.sort.join(",").should == arg1
end

Then /^I should have found high\-homology sub\-tree "([^"]*)"$/ do |arg1|
  @split2.ids.sort.join(",").should == arg1
end


