require 'bio-alignment'
require 'bio-alignment/edit/mask_islands'


Given /^I have an alignment with islands$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
end

When /^I apply island rule with max_gap_size (\d+)$/ do |arg1|
  @aln.extend MaskIslands
  @marked_aln = @aln.mark_islands
end

Then /^it should have masked islands$/ do |string|
  check_aln = Alignment.new(string.split(/\n/))
  new_aln = @marked_aln.update_each_element { |e| (e.state.masked ? Element.new("X"):e)}
  print new_aln.to_s
  new_aln.to_s.should == check_aln.to_s
end

Then /^it should also be able to delete islands$/ do |string|
  pending # express the regexp above with the code you wish you had
end

