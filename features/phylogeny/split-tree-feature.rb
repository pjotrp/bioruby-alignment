When /^I split out branches with a maximum of (\d+) sequences from$/ do |arg1, string|
  tree = @aln.attach_tree(@tree)
  p tree
end

Then /^I should have found "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I split out branches with a minimum of (\d+) and maximum of (\d+) sequences$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I split the tree$/ do |string|
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

