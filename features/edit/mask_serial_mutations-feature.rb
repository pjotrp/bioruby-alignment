require 'bio-alignment'

Given /^I have an alignment$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
end

When /^I apply rule masking with X and max_gap_size (\d+)$/ do |arg1|
  @aln.extend MaskSerialMutations
  # @aln2 = @aln.mark_serial_mutations
  @aln2 = @aln.mask_serial_mutations
end

Then /^mask serial mutations should result in$/ do |string|
  check_aln = Alignment.new(string.split(/\n/))
  new_aln = @aln.del_bridges
  new_aln.to_s.should == check_aln.to_s
end

