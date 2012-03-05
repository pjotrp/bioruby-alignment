require 'bio-alignment/edit/del_short_sequences'

When /^I apply the short sequence rule$/ do
  @aln.extend DelShortSequences
  @aln2 = @aln.mark_short_sequences
end

Then /^it should have removed one row$/ do |string|
  check_aln = Alignment.new(string.split(/\n/))
  new_aln = @aln.del_short_sequences
  print new_aln.to_s
  new_aln.to_s.should == check_aln.to_s
end

Then /^I should be able to track removed rows$/ do
  @aln2.rows.count { |row| row.state.deleted? }.should == 1
  @aln2.rows[0].state.deleted?.should == false
  @aln2.rows[4].state.deleted?.should == true
end


