require 'bio-alignment'
require 'bio-alignment/edit/del_bridges'

Given /^I have a bridged alignment$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
end

When /^I apply the bridge rule$/ do
  @aln.extend DelBridges
  aln2 = @aln.clean
end

Then /^it should have removed (\d+) bridges$/ do |arg1, string|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to track removed columns$/ do
  pending # express the regexp above with the code you wish you had
end


