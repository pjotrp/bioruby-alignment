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
  @aln1 = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/aa-alignment.fa')
  fasta.each do | rec |
    @aln1.sequences << Sequence.new(rec.id, rec.seq)
  end
end

When /^I convert$/ do
  @bioruby_alignment = @aln1.to_bioruby_alignment
end

Then /^I should have a BioRuby Bio::Alignment$/ do
  @bioruby_alignment.consensus_iupac[0..8].should == '???????v?'
end

Given /^I have a BioRuby sequence object$/ do
  @bioseq = Bio::Sequence::NA.new("AGCT")
end

When /^I add RowState$/ do
  require 'bio-alignment/state'
  @bioseq.extend State
  @bioseq.state = RowState.new
  @bioseq.state.deleted?.should == false
end

Then /^I should be able to change the delete state$/ do
  @bioseq.state.delete!
  @bioseq.state.deleted?.should == true
end


