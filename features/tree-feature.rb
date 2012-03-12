require 'bio'  # for the Newick tree parser
require 'bio-alignment'

Given /^I have a multiple sequence alignment \(MSA\)$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
  print @aln
end

Given /^I have a phylogenetic tree in Newick format$/ do |string|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to traverse the tree$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^fetch elements from the MSA from each end node in the tree$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^calculate the phylogenetic distance between each element$/ do
  pending # express the regexp above with the code you wish you had
end

