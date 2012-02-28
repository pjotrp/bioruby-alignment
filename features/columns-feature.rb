Given /^I iterate the columns$/ do
  @aln.should_not be_nil  # aln is loaded by codon-feature.rb
end

column = nil
When /^I fetch a column$/ do
  column = @aln.columns[3]
  column.should_not be_nil
  column[0].to_s.should == 'cga'
end

When /^I inject column state$/ do
  column.state = ColumnState.new
  column.state.deleted = true
end

Then /^I should be able to get the column state$/ do
  column.state.deleted?.should be_true
end

list = []
When /^I iterate a column$/ do
  column10 = @aln.columns[10]
  column10.each do | element | 
    list << element.to_s
  end
end

Then /^I should get the column elements$/ do
  list[0..10].should == 
  ["ctt", "gcg", "ctt", "ttt", "gcg", "ttt", "ttt", "agt", "ttt", "atg", "agt"]
end

