require 'bio-alignment'
require 'bio-alignment/edit/del_bridges'

Given /^I have a bridged alignment$/ do |string|
  @aln = Alignment.new(string.split(/\n/))
end

When /^I apply the bridge rule$/ do
  @aln.extend DelBridges
  @aln2 = @aln.mark_bridges
end

Then /^it should have removed (\d+) bridges$/ do |arg1, string|
  check_aln = Alignment.new(string.split(/\n/))
  new_aln = @aln.del_bridges
  new_aln.to_s.should == check_aln.to_s
end

Then /^I should be able to track removed columns$/ do
  @aln2.columns.count { |col| col.state.deleted? }.should == 6
  @aln2.columns[0].state.deleted?.should == true
  @aln2.columns[8].state.deleted?.should_not == true
end


