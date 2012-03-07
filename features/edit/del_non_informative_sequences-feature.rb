require 'bio-alignment/edit/del_non_informative_sequences'

Given /^I have a bridged alignment containing unknown amino acids$/ do |string|
  @aln = nil
  @aln2 = nil
  @aln = Alignment.new(string.split(/\n/))
  @aln.extend DelNonInformativeSequences
end

When /^I apply the non\-informative sequence rule$/ do
  @aln2 = @aln.mark_non_informative_sequences
end

Then /^it should have removed two rows$/ do |string|
  check_aln = Alignment.new(string.split(/\n/))
  new_aln = @aln.del_non_informative_sequences
  new_aln.to_s.should == check_aln.to_s
end

Then /^I should be able to track removed non\-informative rows$/ do
  @aln2.rows.count { |row| row.state.deleted? }.should == 2
  @aln2.rows[0].state.deleted?.should == false
  @aln2.rows[3].state.deleted?.should == true
  @aln2.rows[4].state.deleted?.should == true
end

