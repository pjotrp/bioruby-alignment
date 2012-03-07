require 'bio-alignment'
require 'bio-alignment/edit/mask_serial_mutations'

Given /^I have an alignment$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
end

When /^I apply rule masking with X and max_gap_size (\d+)$/ do |arg1|
  @aln.extend MaskSerialMutations
  @marked_aln = @aln.mark_serial_mutations
end

Then /^mask serial mutations should result in$/ do |string|
  check_aln = Alignment.new(string.split(/\n/))
  new_aln = @marked_aln.mask_with "X"
  new_aln.to_s.should == check_aln.to_s
end

