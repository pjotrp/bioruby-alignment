$: << 'lib'

require 'bio-alignment'
require 'bigbio'
include Bio::BioAlignment # Namespace

Given /^I read an MSA nucleotide FASTA file in the test\/data folder$/ do
  @aln = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
  fasta.each do | rec |
    @aln.sequences << CodonSequence.new(rec.id, rec.seq)
  end
end

Given /^I iterate the sequence records$/ do
  @aln.rows.each do | seq |
    seq.id != nil
  end
end

When /^I check the alignment$/ do
end

Then /^it should contain codons$/ do
  # first sequence, first codon, translate
  @aln.rows.first[0].to_aa.should == "M"
end

Then /^it should translate to an amino acid MSA$/ do
  aaseq = @aln.rows.first.map { | codon | codon.to_aa }.join("")
  aaseq[0..15].should == 'MPTRLDIVGNLQFSSS'
end

Then /^it should write a nucleotide alignment$/ do
  # Writing is actually handles by a different library
  fasta = FastaWriter.new('test/data/regression/nt-aln.fa')
  @aln.rows.each do | row |
    fasta.write(row)
  end
end

Then /^it should write an amino acid alignment$/ do
  fasta = FastaWriter.new('test/data/regression/aa-aln.fa')
  @aln.rows.each do | row |
    fasta.write(row.id, row.to_aa.to_s)
  end
end

