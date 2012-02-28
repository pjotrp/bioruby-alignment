Given /^I iterate the rows$/ do
  @aln.should_not be_nil  # aln is loaded by codon-feature.rb
end

row = nil
When /^I fetch a row$/ do
  row = @aln.rows[3]
  row.should_not be_nil
  row[0].to_s.should == '---'
end

When /^I inject row state$/ do
  # tell row to handle state
  row.extend(State)
  row.state = RowState.new
  row.state.deleted = true
end

Then /^I should be able to get the row state$/ do
  row.state.deleted?.should be_true
end

list = []
When /^I iterate a row$/ do
  row10 = @aln.rows[10]
  row10.each do | element | 
    list << element.to_s
  end
end

Then /^I should get the row elements$/ do
  list[0..10].should == ["---", "---", "---", "---", "---", "---", "---", "atg", "tcg", "tcc", "agt"]

end

