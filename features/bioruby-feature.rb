require 'bio'  # yes, we use BioRuby here

$: << 'lib'

require 'bio-alignment/bioruby'

Given /^I have multiple Bio::Sequence objects$/ do
  @list = []
  # Read a Fasta file
  fasta = Bio::FlatFile.open(Bio::FastaFormat, 'test/data/fasta/codon/codon-alignment.fa')
  fasta.each_entry do |f|
    naseq = f.naseq
    # test we can index the sequence
    ['a','-'].index(naseq[0]).should_not be nil
    @list << naseq # inject Bio::Sequence object
  end
end

When /^I assign BioAlignment$/ do
  @aln = Alignment.new
end

Then /^it should accept the objects$/ do
  @list.each do | bioruby_naseq |
    @aln.sequences << bioruby_naseq
  end
end

Then /^and return a partial sequence$/ do
  @aln.rows[0][0..8].should == 'atgcccact'
end

Then /^be indexable$/ do
  @aln.rows[0][0].should == 'a'
end

# ---

Given /^I have multiple Bio::Sequence::AA objects$/ do
  @aalist = []
  # Read a Fasta file
  fasta = Bio::FlatFile.open(Bio::FastaFormat, 'test/data/fasta/codon/aa-alignment.fa')
  fasta.each_entry do |f|
    aaseq = f.aaseq
    @aalist << aaseq # inject Bio::Sequence object
  end
end

When /^I assign BioAlignment for AA$/ do
  @aa_aln = Alignment.new
end

Then /^it should accept the Bio::Sequence::AA objects$/ do
  @aalist.each do | bioruby_aaseq |
    @aa_aln.sequences << bioruby_aaseq
  end
end

Then /^and return a partial AA sequence$/ do
  @aa_aln.rows[0][0..8].should == 'MPTRLDIVG'
end

Then /^be AA indexable$/ do
  @aa_aln.rows[0][0].should == 'M'
end

# ----

Given /^I have a BioAlignment$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I convert$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should have a Bio::Alignment$/ do
  pending # express the regexp above with the code you wish you had
end

