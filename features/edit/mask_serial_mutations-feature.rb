require 'bio-alignment'

Given /^I have an alignment$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
  p @aln
end

When /^I apply rule masking with X and max_gap_size (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^it should have removed (\d+) islands$/ do |arg1, string|
  pending # express the regexp above with the code you wish you had
end

