require 'bio-alignment'
require 'bio-alignment/edit/mask_serial_mutations'

Given /^I have an alignment$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
end

When /^I apply rule masking with X$/ do 
  @aln.extend MaskSerialMutations
  @marked_aln = @aln.mark_serial_mutations
end

Then /^mask serial mutations should result in$/ do |string|
  check_aln = Alignment.new(string.split(/\n/))
  new_aln = @marked_aln.update_each_element { |e| (e.state.masked ? Element.new("X"):e)}
  new_aln.to_s.should == check_aln.to_s
end

